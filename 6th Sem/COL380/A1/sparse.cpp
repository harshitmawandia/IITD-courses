#include <bits/stdc++.h>
#include "library.hpp"
#include <omp.h>

class sparse_matrix
{
public:
    vector<pair<int,pair<int,int>>> data;

    int row, col;
    int len;
 

    sparse_matrix(int r)
    {
        row = r;
        col = r;
        len = 0;            
    }
 
    // insert elements into sparse matrix
    void insert(int r, int c, int val)
    {
 
        // invalid entry
        if (r > row || c > col)
        {
            cout << "Wrong entry";
        }
        else
        {   
            pair<int,int> t;
            t.first = c;
            t.second = val;
            data.push_back(make_pair(r,t));
            len++;
        }
    }
 
    sparse_matrix transpose()
    {
        sparse_matrix result(row);
        result.len = len;
        result.data.resize(len);
        
        long *count = new long[col + 1];

        for (long long i = 0; i <= col; i++)
            count[i] = 0;

        for (long long i = 0; i < len; i++){
            count[data[i].second.first]++;
        }
 
        long long *index = new long long[col + 1];
 
        index[0] = 0;
 
        // initialize rest of the indices
        for (long long i = 1; i <= col; i++){ 
            index[i] = index[i - 1] + count[i - 1];
        }

 
        for ( long long i = 0; i < len; i++)
        {
 
            long long rpos = index[data[i].second.first]++;
            result.data[rpos].first = data[i].second.first;
            result.data[rpos].second.first = data[i].first;
            result.data[rpos].second.second = data[i].second.second;
        }
        return result;
    }
 
    void multiply(sparse_matrix b, sparse_matrix &result)
    {
        if (col != b.row)
        {
            cout << "Can't multiply, Invalid dimensions";
            return;
        }

        int apos_arr[row+1] = {0};
        int bpos_arr[row+1] = {0};
        for(int i = 1; i< row; i++){
            apos_arr[i] = apos_arr[i-1];
            while(data[apos_arr[i]].first == i){
                apos_arr[i]++;
            }
            bpos_arr[i] = bpos_arr[i-1];
            while(b.data[bpos_arr[i]].first == i){
                bpos_arr[i]++;
            }
        }
 
        omp_set_num_threads(8);

        #pragma omp parallel for shared(apos_arr, bpos_arr, result)
        for (int i = 0; i < row; i++)
        {
            int apos = apos_arr[i];
            int r = data[apos].first;
            {
                for (int j = 0; j < row; j++)
                {
                    int bpos = bpos_arr[j];
                    int c = b.data[bpos].first;

                    int tempa = apos;
                    int tempb = bpos;
    
                    int sum = 0;
    
                    while (tempa < len && data[tempa].first == r &&
                        tempb < b.len && b.data[tempb].first == c)
                    {
                        if (data[tempa].second.first < b.data[tempb].second.first)
    
                            // skip a
                            tempa++;
    
                        else if (data[tempa].second.first > b.data[tempb].second.first)
    
                            // skip b
                            tempb++;
                        else
    
                            // same col, so multiply and increment
                            sum = Outer(Inner(data[tempa].second.second, b.data[tempb].second.second), sum);
                            tempa++;
                            tempb++;
                    }
                    if (sum != 0){
                        #pragma omp critical
                        {
                        result.insert(r, c, sum);
                        }
                    }
                }
            }
        }
        // print();
    }
 
    // printing matrix
    void print()
    {
        //sparse to dense
        int **dense = new int*[row];
        for(int i = 0; i < row; i++){
            dense[i] = new int[col];
            for(int j = 0; j < col; j++){
                dense[i][j] = 0;
            }
        }
        for(int i = 0; i < len; i++){
            dense[data[i].first][data[i].second.first] = data[i].second.second;
        }
        for(int i = 0; i < row; i++){
            for(int j = 0; j < col; j++){
                cout << dense[i][j] << " ";
            }
            cout << endl;
        }
    }
};

bool compare(pair<int, pair<int, int>> a, pair<int, pair<int, int>> b){
    if(a.first == b.first){
        return a.second.first < b.second.first;
    }
    return a.first < b.first;
}


void executeSparse(string input){
    ifstream fin(input, ios::binary);
    if (!fin) {
        std::cerr << "Error: unable to open input file." << std::endl;
        return ;
    }

    int n, m, k;
    fin.read((char*)&n, sizeof(int));
    fin.read((char*)&m, sizeof(int));
    fin.read((char*)&k, sizeof(int));

    // cout << n << " " << m << " " << k << endl;

    sparse_matrix matrix(n);

    for(int i = 0; i<k; i++) {
        int x, y;
        fin.read((char*)&x, sizeof(int));
        fin.read((char*)&y, sizeof(int));
        for(int j=0; j<m; j++){
            for(int l=0; l<m; l++){
                uint8_t temp;
                fin.read((char*)&temp, sizeof(uint8_t));
                matrix.insert(x*m+j, y*m+l, temp);
                if(x*m+j != y*m+l)
                    matrix.insert(y*m+l, x*m+j, temp);
            }
        }
    }

    sort(matrix.data.begin(), matrix.data.end(), compare);

    sparse_matrix result(n);

    double start = omp_get_wtime();
    matrix.multiply(matrix, result);
    double end = omp_get_wtime();
    cout << "Sparse: " << end - start << endl;

    // result.print();

    uint16_t **dense = new uint16_t*[n];
    for(int i = 0; i < n; i++){
        dense[i] = new uint16_t[n];
        for(int j = 0; j < n; j++){
            dense[i][j] = 0;
        }
    }

    for(int i = 0; i < result.len; i++){
        dense[result.data[i].first][result.data[i].second.first] = result.data[i].second.second;
    }

    k = 0;
    vector<vector<vector<uint16_t>>> blocks;
    vector<pair<int,int>> block_pos;
    for(int i=0;i<n/m;i++){
        for(int j=0;j<n/m;j++){
            bool flag = false;
            vector<vector<uint16_t>> block;
            for(int l=0;l<m;l++){
                vector<uint16_t> row;
                for(int o=0;o<m;o++){
                    if(dense[i*m+l][j*m+o] != 0){
                        flag = true;
                        row.push_back(dense[i*m+l][j*m+o]);
                    }
                    else{
                        row.push_back(0);
                    }
                }
                block.push_back(row);
            }
            if(flag){
                blocks.push_back(block);
                block_pos.push_back(make_pair(i,j));
                k++;
            }
        }
    }

    //output
    ofstream fout("output.bin", ios::binary);
    fout.write((char*)&n, sizeof(int));
    fout.write((char*)&m, sizeof(int));
    fout.write((char*)&k, sizeof(int));

    for(int i=0;i<k;i++){
        fout.write((char*)&block_pos[i].first, sizeof(int));
        fout.write((char*)&block_pos[i].second, sizeof(int));
        for(int j=0;j<m;j++){
            for(int l=0;l<m;l++){
                fout.write((char*)&blocks[i][j][l], sizeof(uint16_t));
            }
        }
    }
}


int main(int argc, char *argv[]) {
    string input = argv[1];
    
    executeSparse(input);

    return 0;
}