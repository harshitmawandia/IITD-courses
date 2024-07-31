#include <bits/stdc++.h>
#include "library.hpp"
#include <omp.h>

class sparse_matrix
{
    // the triple-represented form
public:
    vector<pair<int,pair<int,int>>> data;
 
    int row, col;
 
    // total number of elements in matrix
    int len;
    sparse_matrix(int r)
    {
 
        // initialize row
        row = r;
 
        // initialize col
        col = r;
 
        // initialize length to 0
        len = 0;
 
        //Array of Pointer to make a matrix
            
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

 
            // increment number of data in matrix
            len++;
        }
    }
 
    sparse_matrix transpose()
    {
 
        // new matrix with inversed row X col
        sparse_matrix result(row);
        // same number of elements
        result.len = len;
        result.data.resize(len);
        
 
        // to count number of elements in each column
        long *count = new long[col + 1];

 
        // initialize all to 0
        for (long long i = 0; i <= col; i++)
            count[i] = 0;

        cout << count[0] << endl;
 
        for (long long i = 0; i < len; i++){
            count[data[i].second.first]++;
            // cout << count[data[i].second.first] << endl;
        }
 
        long long *index = new long long[col + 1];
 
        // to count number of elements having
        // col smaller than particular i
 
        // as there is no col with value < 0
        index[0] = 0;
 
        // initialize rest of the indices
        for (long long i = 1; i <= col; i++){ 
            index[i] = index[i - 1] + count[i - 1];
            // cout << index[i] << " " << index[i-1] << " " << count[i-1] << endl;
        }

 
        for ( long long i = 0; i < len; i++)
        {
 
            // insert a data at rpos and
            // increment its value
            long long rpos = index[data[i].second.first]++;
 
            // transpose row=col
            result.data[rpos].first = data[i].second.first;
            // cout << result.data[rpos].first << " " << result.data[rpos].second.first << endl;
 
            // transpose col=row
            result.data[rpos].second.first = data[i].first;
            // cout << result.data[rpos].first << " " << result.data[rpos].second.first << endl;
 
            // same value
            result.data[rpos].second.second = data[i].second.second;
        }
 
        // the above method ensures
        // sorting of transpose matrix
        // according to row-col value
        return result;
    }
 
    void multiply(sparse_matrix b, sparse_matrix &result)
    {
        if (col != b.row)
        {
 
            // Invalid multiplication
            cout << "Can't multiply, Invalid dimensions";
            return;
        }
 
        // transpose b to compare row
        // and col values and to add them at the end
        b = b.transpose();
        // int apos, bpos;
        // cout << "Multiplication of matrices: " << endl;
        // result matrix of dimension row X b.col
        // however b has been transposed,
        // hence row X b.row

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
        // iterate over all elements of A
        #pragma omp parallel for
        for (int i = 0; i < row; i++)
        {
            int apos = apos_arr[i];
            // current row of result matrix
            int r = data[apos].first;
 
            // iterate over all elements of B
            {
                for (int j = 0; j < row; j++)
                {
                    int bpos = bpos_arr[j];
                    // current column of result matrix
                    // data[,0] used as b is transposed
                    int c = b.data[bpos].first;

                    int tempa = apos;
                    int tempb = bpos;
    
                    int sum = 0;
    
                    // iterate over all elements with
                    // same row and col value
                    // to calculate result[r]
                    while (tempa < len && data[tempa].first == r &&
                        tempb < b.len && b.data[tempb].first == c)
                    {
                        if (data[tempa].second.first < b.data[tempb].second.first){
    
                            // skip a
                            cout << data[tempa].second.first << " " << b.data[tempb].second.first << endl;
                            tempa++;
                        }
    
                        else if (data[tempa].second.first > b.data[tempb].second.first){
                            cout <<" Else if " << endl;
                            // skip b
                            tempb++;
                        }
                        else
                            {
                            // same col, so multiply and increment
                            cout << data[tempa].second.first << " " << b.data[tempb].second.first << endl;
                            sum = Outer(Inner(data[tempa].second.second, b.data[tempb].second.second), sum);
                            }
                    }
                    // cout << rand() << endl;
                    // insert sum obtained in result[r]
                    // if its not equal to 0
                    if (sum != 0)
                        // #pragma omp critical
                        {
                        cout << "inserting " << r << " " << c << " " << sum << endl;
                        result.insert(r, c, sum);
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

    cout << n << " " << m << " " << k << endl;

    sparse_matrix matrix(n);

    for(int i = 0; i<k; i++) {
        int x, y;
        fin.read((char*)&x, sizeof(int));
        fin.read((char*)&y, sizeof(int));
        for(int j=0; j<m; j++){
            for(int l=0; l<m; l++){
                uint8_t temp;
                fin.read((char*)&temp, sizeof(uint8_t));
                if(temp != 0)
                matrix.insert(x*m+j, y*m+l, temp);
                
            }
        }
    }


    sparse_matrix result(n);

    double start = omp_get_wtime();
    matrix.multiply(matrix, result);
    double end = omp_get_wtime();
    cout << "Sparse: " << end - start << endl;

    //sparse to dense
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

    for(int i = 0; i < n; i++){
        for(int j = i; j < n; j++){
            dense[j][i] = 0 ;
        }
    }

    //finding non empty blocks[n/m][n/m][m][m] of size m*m
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