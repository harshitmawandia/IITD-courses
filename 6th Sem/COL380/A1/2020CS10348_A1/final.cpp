#include <bits/stdc++.h>
#include "library.hpp"
#include <omp.h>

#define NUM_THREADS 8

struct block{
    vector<int> matrix;
    int is_not_zero=0;
};

using namespace std;

void multiply_block(block &a, block &b, block &c, int m, bool &flag){
    for(int i=0;i<m;i++){
        for(int j=0;j<m;j++){
            int temp = c.matrix[i*m+j];
            for(int k=0;k<m;k++){
                temp= Outer(Inner(a.matrix[i*m+k], b.matrix[j*m + k]), temp) ;
                cout << temp << endl;
            }
            if(temp!=0){
                flag = true;
            }
            c.matrix[i*m+j] = min(temp,65535);
        }
    }
}

int main(int argc, char *argv[]){
    string filename = argv[1];
    string outputFile = argv[2];
    ifstream file(filename, ios::binary);

    

    int n, m, k;
    file.read((char*)&n, sizeof(int));
    file.read((char*)&m, sizeof(int));
    file.read((char*)&k, sizeof(int));

    cout << n << " " << m << " " << k << endl;

    vector<vector<block>> block_map(n/m, vector<block>(n/m));

    for(int i=0;i<k;i++){
        int x, y;
        file.read((char*)&x, sizeof(int));
        file.read((char*)&y, sizeof(int));
        block block;
        for(int j=0;j<m;j++){
            for(int l=0;l<m;l++){
                int temp;
                file.read((char*)&temp, sizeof(uint8_t));
                block.matrix.push_back(temp);
            }
        }
        block.is_not_zero = 1;
        if(x!=y){
            block_map[x][y] = block;
            block_map[y][x] = block;
        }else{
            block_map[x][y] = block;
        }
    }

    file.close();

    vector<vector<block>> result(n/m, vector<block>(n/m));
    int count = 0;

    omp_set_num_threads(NUM_THREADS);

    double start = omp_get_wtime();

    #pragma omp parallel for schedule(dynamic) reduction(+:count)
    for (int i = 0; i < n / m; i++) {
        #pragma omp taskgroup
        {
            for (int j = i; j < n / m; j++) {
                block temp;
                temp.matrix.resize(m * m);
                bool flag = false;

                for (int l = 0; l < n / m; l++) {
                    if (block_map[i][l].is_not_zero && block_map[j][l].is_not_zero) {
                        multiply_block(block_map[i][l], block_map[j][l], temp, m, flag);
                    }
                }
                if(i==0 && j==0){
                    for(int l=0;l<m;l++){
                        for(int k=0;k<m;k++){
                            cout << temp.matrix[l*m+k] << " ";
                        }
                        cout << endl;
                    }
                }

                if (flag) {
                    temp.is_not_zero = 1;
                    #pragma omp critical
                    {
                        result[i][j] = temp;
                    }
                    count++;
                }
            }
        }
    }
    double end = omp_get_wtime();
    cout << "Final: " << end - start << endl;


    cout << count << endl;

    //output

    ofstream output(outputFile, ios::binary);
    output.write((char*)&n, sizeof(int));
    output.write((char*)&m, sizeof(int));
    output.write((char*)&count, sizeof(int));

    for(int i=0;i<n/m;i++){
        for(int j=i;j<n/m;j++){
            if(result[i][j].is_not_zero){
                output.write((char*)&i, sizeof(int));
                output.write((char*)&j, sizeof(int));
                // cout << i << " " << j << endl;
                for(int l=0;l<m;l++){
                    for(int k=0;k<m;k++){
                        uint16_t temp = (uint16_t)result[i][j].matrix[l*m+k];
                        output.write((char*)&temp, sizeof(uint16_t));
                    }
                }
            }
        }
    }

    output.close();

    return 0;
}