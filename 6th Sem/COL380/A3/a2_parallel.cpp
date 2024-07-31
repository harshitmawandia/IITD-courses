#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <queue>
#include <algorithm>
#include <set>
#include <unistd.h>
#include <unordered_set>
#include <mpi.h>
#include <chrono>
#include <omp.h>


using namespace std;


void readInputFromFile(const string& filename, int& n, int& m, map<int,set<int> >& adjList) {
    ifstream infile(filename, ios::binary); 
    if (!infile.is_open()) { 
        cerr << "Error: Failed to open file \"" << filename << "\"" << endl;
        exit(1); 
    }

    infile.read(reinterpret_cast<char*>(&n), sizeof(n)); 

    infile.read(reinterpret_cast<char*>(&m), sizeof(m)); 
     

    for (int i = 0; i < n; i++) {
        int node,k;
        infile.read(reinterpret_cast<char*>(&node), sizeof(node)); 
        infile.read(reinterpret_cast<char*>(&k), sizeof(k));
        for (int j = 0; j < k; j++) {
            int temp;
            infile.read(reinterpret_cast<char*>(&temp), sizeof(temp)); 
            adjList[node].insert(temp);
        }
    }
    infile.close();
}

void dfs(map<int,set<int>>& adjList, vector<bool> &visited, int v, vector<int> &verts) {
    if(visited[v] == true) return;

    visited[v] = true;
    verts.push_back(v);

    for(int u: adjList[v]) {
        if(u!=v) {
            // cout<<u<<" ";
            dfs(adjList, visited, u, verts);
        }
    }
}


void filterEdges(map<int,set<int> >& adjList,map<pair<int,int>,int>& supp,int k,set<pair<int,int> >& deletable2){
    //filter edges
    set<pair<int, int>> procEdges;
    map<pair<int, int>, int> ownerp;

    int procRank, num_procs;
    MPI_Comm_rank( MPI_COMM_WORLD, &procRank);
    MPI_Comm_size (MPI_COMM_WORLD, &num_procs);


    vector<pair<int, int>> edges;
    for(auto it=adjList.begin(); it!=adjList.end(); it++){
        for(auto it2=it->second.begin(); it2!=it->second.end(); it2++){
            if(it->first<*it2){
                edges.push_back(make_pair(it->first,*it2));
            }
        }
    }
    

    int chunk = edges.size()/(num_procs) + 1;
    int start = procRank*chunk;
    int end = min((procRank+1)*chunk, (int)edges.size());
    // cout << "procRank: " << procRank << " start: " << start << " end: " << end << " chunk: " << chunk << " edges.size(): " << edges.size() <<" numProcs:"  << num_procs<< endl;

    for(int i=start; i<end; i++){
        procEdges.insert(edges[i]);
    }
    
    for(int i=0; i<edges.size(); i++){
        ownerp[edges[i]]=i/chunk;
    }


    deque<pair<int, int>> procDeletable;

    for(auto i : deletable2) {
        if(procEdges.find(i)!=procEdges.end()) {
            procDeletable.push_back(i);
        }
    }

    int counts[num_procs];
    int sdispls[num_procs];
    int sedgedispls[num_procs];
    int sendingEdgeCount[num_procs];
    
    int rdispls[num_procs];
    int redgedispls[num_procs];
    int recvedgecounts[num_procs];

    for(int i = 0; i<num_procs; i++) {
        counts[i]=3;
        sdispls[i] = 3*i;
        rdispls[i] = 3*i;
    }

    bool all_fin = false;

    while(!all_fin){
        vector<int> recvbuf(3*num_procs);
        vector<int> sendingBuffer(3*num_procs);
        set<pair<pair<int, int>, int>> sedningEdges[num_procs];

        for(int i=0; i<num_procs; i++)sendingEdgeCount[i]=0;

        int count = 0;
        if(procDeletable.empty() == false) {
           
            auto e = procDeletable.front();

            procDeletable.pop_front();
            procEdges.erase(e);
            // my_edge_map[e] = false;
            
            int x1 = e.first, y1 = e.second;
            for(auto a: adjList[x1]) {
                if(adjList[y1].find(a)!=adjList[y1].end()) {
                    
                    pair<int, int> ax={min(x1, a), max(x1, a)}, ay={min(y1, a), max(y1, a)};
                    sendingEdgeCount[ownerp[ax]]+=3;
                    sendingEdgeCount[ownerp[ay]]+=3;
                    sedningEdges[ownerp[ax]].insert({ax, y1});
                    sedningEdges[ownerp[ay]].insert({ay, x1});

                }
            }
            
            for(int it1 = 0; it1<num_procs; it1++) {
                sendingBuffer[3*it1] = e.first;
                sendingBuffer[3*it1 + 1] = e.second;
                sendingBuffer[3*it1+2] = sendingEdgeCount[it1]/3;
            }
        } else {
            for(int it1 = 0; it1<num_procs; it1++) {
                sendingBuffer[3*it1] = -1;
                sendingBuffer[3*it1 + 1] = -1;
                sendingBuffer[3*it1+2] = 0;
            }
        }

        // Call MPI_alltoallv to send and receive data
        MPI_Alltoallv(sendingBuffer.data(), counts, sdispls, MPI_INT,
                      recvbuf.data(), counts, rdispls, MPI_INT,
                      MPI_COMM_WORLD);


        int total_edges_to_recv = 0;
        for(int i = 0;i<num_procs; i++) {
            int ll = recvbuf[3*i];
            total_edges_to_recv += recvbuf[3*i + 2];
        }
        vector<int> sendedgebuf;
        int l = 0;
        vector<int> receivingEdgeBuffer(3*total_edges_to_recv, -5);
        sedgedispls[0] = 0;
        int x = 2;
        redgedispls[0] = 0;
        for(int i=0; i<num_procs; i++){
            if(i!=0)sedgedispls[i]=sedgedispls[i-1] + sendingEdgeCount[i-1]; 
            for( pair<pair<int, int>, int> e : sedningEdges[i]){
                sendedgebuf.push_back(e.first.first);
                x = e.first.first;
                sendedgebuf.push_back(e.first.second);
                x = e.second;
                sendedgebuf.push_back(e.second);

            }
        }
        for(int i = 0; i<num_procs; i++) {
            
            int x1=recvbuf[3*i], y1=recvbuf[3*i+1];
            
            if(x1!=-1){
                if(adjList[x1].find(y1)!=adjList[x1].end()) {
                    adjList[x1].erase(y1);
                }
                if(adjList[y1].find(x1)!=adjList[y1].end()){
                    adjList[y1].erase(x1);
                }
            }
            else count++;
            
            recvedgecounts[i] = 3*recvbuf[3*i + 2];
            if(i > 0) {
                redgedispls[i] = redgedispls[i-1] + recvedgecounts[i-1];
            }
        }
    


        MPI_Alltoallv(sendedgebuf.data(), sendingEdgeCount, sedgedispls, MPI_INT,
                        receivingEdgeBuffer.data(), recvedgecounts, redgedispls, MPI_INT,
                        MPI_COMM_WORLD);

        set<pair<pair<int, int>, int>> deleted;
            for(int it1 = 0; it1<receivingEdgeBuffer.size(); it1+=3) {
                pair<pair<int, int>, int> ed = { make_pair(receivingEdgeBuffer[it1], receivingEdgeBuffer[it1 + 1]), receivingEdgeBuffer[it1 + 2] };
                pair<int, int> ed1=ed.first;
                if(deleted.find(ed)==deleted.end()){
                    deleted.insert(ed);
                    if(procEdges.find(ed1) != procEdges.end()) {
                        supp[ed1] --;
                        if(supp[ed1] < k-2 && find(procDeletable.begin(), procDeletable.end(), ed1) == procDeletable.end()) {
                            procDeletable.push_back(ed1);
                        }
                    }
                }
            }

        if(count == num_procs) {
            break;
        }

    }
}

int main(int argc, char* argv[]) {

    //input options
    int taskid = -1;
    std::string inputpath;
    std::string headerpath;
    std::string outputpath;
    int verbose = -1;
    int startk = -1;
    int endk = -1;
    int p = -1;
    std::vector<std::string> args(argv, argv + argc);
    for (size_t i = 0; i < args.size(); i++) {
         std::string arg = argv[i];
        if (arg.substr(0, 9) == "--taskid=") {
        taskid = std::stoi(arg.substr(9));
        } else if (arg.substr(0, 12) == "--inputpath=") {
        inputpath = arg.substr(12);
        } else if (arg.substr(0, 13) == "--headerpath=") {
        headerpath = arg.substr(13);
        } else if (arg.substr(0, 13) == "--outputpath=") {
        outputpath = arg.substr(13);
        } else if (arg.substr(0, 10) == "--verbose=") {
        verbose = std::stoi(arg.substr(10));
        } else if (arg.substr(0, 9) == "--startk=") {
        startk = std::stoi(arg.substr(9));
        } else if (arg.substr(0, 7) == "--endk=") {
        endk = std::stoi(arg.substr(7));
        } else if (arg.substr(0, 4) == "--p=") {
        p = std::stoi(arg.substr(4));
        }
    }

    int supported;
    MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &supported);

    if (supported != MPI_THREAD_MULTIPLE) {
        printf("MPI_THREAD_MULTIPLE not supported\n");
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    if(taskid==2){
        startk = endk;
    }
    // cout << "startk: " << startk << " endk: " << endk << " taskid: " << taskid << endl;

    auto begin = std::chrono::high_resolution_clock::now();
    //start
    int n,m;
    map<int,set<int> > adjList, original_graph;
    cout << "inputpath: " << inputpath << endl;
    readInputFromFile(inputpath,n,m,adjList);
    cout << "n: " << n << " m: " << m << endl;
    map<pair<int,int>,int> supp;
    int myrank;
    MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
    ofstream outfile;
    if(myrank==0){
        outfile.open(outputpath, ios::out);
        original_graph = adjList;
    }


    for(int k = startk+2; k <= endk+2; k++){

        //prefilter
        queue<int> deletable;
        for (auto it=adjList.begin();it!=adjList.end();it++){
            if (it->second.size()<k-1){
                deletable.push(it->first);
            }
        }
        while(deletable.size()>0){
            int temp=deletable.front();
            deletable.pop();
            for (auto it=adjList[temp].begin();it!=adjList[temp].end();it++){
                adjList[*it].erase(temp);
                if (adjList[*it].size()<k - 1){
                    deletable.push(*it);
                }
            }
            adjList.erase(temp);
        }

        map<pair<int,int>,int> supp;
        
        //initialize
        set<pair<int,int> > deletable2;

        // omp_set_num_threads(4); 

        // #pragma omp parallel
        for (auto tempset:adjList){
            int a = tempset.first;
            for (auto b:tempset.second){
                if(a<b){
                    set<int> Intersection;
                    insert_iterator<set<int> > IntersectIterate(Intersection, Intersection.begin());
                    set_intersection(adjList[a].begin(), adjList[a].end(), adjList[b].begin(), adjList[b].end(), IntersectIterate);
                    int supp_e=Intersection.size();
                    // #pragma omp critical
                    supp[{a,b}] = supp_e;
                    // cout << a << " " << b << " " << supp_e << endl;
                    if (supp_e<k - 2){
                        // #pragma omp critical
                        deletable2.insert({a,b});
                    }
                }
            }
        }

        filterEdges(adjList,supp,k, deletable2);
        


        //output
        if(myrank == 0){
            // cout << "k = " << k << endl;
            if(adjList.size()!=0){
                bool flag = true;
                auto it = adjList.begin();
                while(it!=adjList.end()){
                    if(it->second.size()!=0){
                        flag = false;
                        it++;
                    }else{
                        //delete it;
                        adjList.erase(it++);
                    }
                }
                if(!flag && taskid==1){
                    if(verbose==0){
                        outfile << "1 ";
                    }
                    if(verbose==1){
                        outfile << "1" << endl;
                        vector<vector<int>> components;
                        vector<bool> visited(n+1,0);
                        for(auto temp:adjList){
                            if(visited[temp.first]==0){
                                vector<int> component;
                                dfs(adjList,visited,temp.first,component);
                                components.push_back(component);
                            }
                        }
                        // std::cout << "components size = " << components.size() << endl;
                        outfile<<components.size()<<endl;
                        for(auto component:components){
                            sort(component.begin(),component.end());
                            for(auto node:component){
                                outfile<<node<<" ";
                            }
                            outfile<<endl;
                        }
                    }
                }else if(!flag && taskid==2){
                    vector<vector<int>> components;
                    vector<bool> visited(n+1,0);
                    for(auto temp:adjList){
                        if(visited[temp.first]==0){
                            vector<int> component;
                            dfs(adjList,visited,temp.first,component);
                            components.push_back(component);
                        }
                    }
                    vector<int> group_number(n,-1);
                    for(int i=0;i<components.size();i++){
                        for(auto node:components[i]){
                            group_number[node] = i;
                        }
                    }
                    set<int> isInfluencer;
                    int countInfluencer = 0;
                    for(int i=0;i<n;i++){
                        vector<int> groups_visited(components.size(),0);
                        int count = 0;
                        for(auto j:original_graph[i]){
                            if(group_number[j] != -1 && groups_visited[group_number[j]] == 0){
                                groups_visited[group_number[j]] = 1;
                                count++;
                            }
                        }
                        if(count >= p){
                            isInfluencer.insert(i);
                            countInfluencer++;
                        }
                        // cout << count << " ";
                    }
                    if(countInfluencer==0){
                        outfile<<"0"<<endl;
                    }
                    else{
                        outfile<<countInfluencer<<endl;
                        if(verbose!=1){
                            for(auto node:isInfluencer){
                                outfile<<node<<" ";
                            }
                        }else{
                            for(auto node:isInfluencer){
                                outfile<<node<<endl;
                                vector<int> groups_visited(components.size(),0);
                                for(auto j: original_graph[node]){
                                    if(group_number[j] != -1 && groups_visited[group_number[j]] == 0){
                                        groups_visited[group_number[j]] = 1;
                                        for(auto k:components[group_number[j]]){
                                            outfile<<k<<" ";
                                        }
                                    }
                                }
                                outfile<<endl;
                            }
                        }
                    }
                }
                else{
                    if(taskid==1)
                        outfile<<"0 ";
                    else if(taskid==2)
                        outfile<<"0"<<endl;
                }
            }
            else{
                if(taskid==1)
                    outfile<<"0 ";
                else if(taskid==2)
                    outfile<<"0"<<endl;
            }
        }
    }
    auto end = std::chrono::high_resolution_clock::now();
    float computation_time = (1e-6 * (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count());
    if(myrank == 0) {
        cout <<"Time for computation: "<< computation_time << " ms\n";
    }
    MPI_Finalize();
    return 0;
}