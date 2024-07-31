#include <bits/stdc++.h>
#include "library.hpp"
#include <omp.h>

using namespace std;

#define MAX_VAL (uint16_t)65535

#define NUM_THREADS 8

int n;

void multiply_simple(uint8_t *matrix, uint16_t *multiply_result, int n) {
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            uint16_t temp = Inner(matrix[i*n + 0], matrix[0*n + j]);
            for(int k=1; k<n; k++){
                temp = Outer(multiply_result[i*n + j], Inner(matrix[i*n + k], matrix[k*n + j]));
            }
            multiply_result[i*n + j] = temp;
        }
    }
}

void multiply_simple_2D(uint8_t **matrix, uint16_t **multiply_result, int n) {
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            uint16_t temp = Inner(matrix[i][0], matrix[0][j]);
            for(int k=1; k<n; k++){
                temp = Outer(multiply_result[i][j], Inner(matrix[i][k], matrix[k][j]));
            }
            multiply_result[i][j] = temp;
        }
    }
}
    

void multiply_with_transpose(uint8_t *matrix, uint16_t *multiply_result, int n) {
    uint8_t *transpose;
    transpose = (uint8_t *)malloc(n*n*sizeof(uint8_t));
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            transpose[i*n + j] = matrix[j*n + i];
        }
    }

    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            uint16_t temp = Inner(matrix[i*n + 0], transpose[j*n + 0]);
            for(int k=1; k<n; k++){
                temp = Outer(multiply_result[i*n + j], Inner(matrix[i*n + k], transpose[j*n + k]));
            }
            multiply_result[i*n + j] = temp;
        }
    }
    free(transpose);
}

void multiply_with_transpose_2D(uint8_t **matrix, uint16_t **multiply_result, int n){
    uint8_t transpose[n][n];
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            transpose[i][j] = matrix[j][i];
        }
    }

    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            uint16_t temp = Inner(matrix[i][0], transpose[j][0]);
            for(int k=1; k<n; k++){
                temp = Outer(multiply_result[i][j], Inner(matrix[i][k], transpose[j][k]));
            }
            multiply_result[i][j] = temp;
        }
    }
}

void mutiply_parallel(uint8_t *matrix, uint16_t *multiply_result, int n) {

    omp_set_num_threads(NUM_THREADS);

    #pragma omp parallel for
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            int temp = Inner(matrix[i*n + 0], matrix[0*n + j]);
            for(int k=1; k<n; k++){
                temp = Outer(multiply_result[i*n + j], Inner(matrix[i*n + k], matrix[k*n + j]));
            }
            multiply_result[i*n + j] = temp;
        }
    }
}

void mutiply_parallel_2D(uint8_t **matrix, uint16_t **multiply_result, int n) {

    omp_set_num_threads(NUM_THREADS);

    #pragma omp parallel for
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            int temp = Inner(matrix[i][0], matrix[0][j]);
            for(int k=1; k<n; k++){
                temp = Outer(multiply_result[i][j], Inner(matrix[i][k], matrix[k][j]));
            }
            multiply_result[i][j] = temp;
        }
    }
}

void mutiply_parallel_with_transpose(uint8_t *matrix, uint16_t *multiply_result, int n) {
    uint8_t *transpose;
    transpose = (uint8_t *)malloc(n*n*sizeof(uint8_t));

    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            transpose[i*n + j] = matrix[j*n + i];
        }
    }

    omp_set_num_threads(NUM_THREADS);

    #pragma omp parallel for
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            int temp = Inner(matrix[i*n + 0], transpose[j*n + 0]);
            for(int k=1; k<n; k++){
                temp = Outer(multiply_result[i*n + j], Inner(matrix[i*n + k], transpose[j*n + k]));
            }
            multiply_result[i*n + j] = temp;
        }
    }
    free(transpose);
}

void mutiply_parallel_with_transpose_2D(uint8_t **matrix, uint16_t **multiply_result, int n) {
    uint8_t transpose[n][n];

    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            transpose[i][j] = matrix[j][i];
        }
    }

    omp_set_num_threads(NUM_THREADS);

    #pragma omp parallel for
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++){
            int temp = Inner(matrix[i][0], transpose[j][0]);
            for(int k=1; k<n; k++){
                temp = Outer(multiply_result[i][j], Inner(matrix[i][k], transpose[j][k]));
            }
            multiply_result[i][j] = temp;
        }
    }
}

void input_with_2D_array(string input){
    ifstream fin(input, ios::binary);
    if (!fin) {
        std::cerr << "Error: unable to open input file." << std::endl;
        return ;
    }

    int  m, k;
    fin.read((char*)&n, sizeof(int));
    fin.read((char*)&m, sizeof(int));
    fin.read((char*)&k, sizeof(int));

    cout << n << " " << m << " " << k << endl;

    uint8_t **matrix = new uint8_t*[n];
    for(int i=0; i<n; i++){
        matrix[i] = new uint8_t[n];
    }
    // cout << n*n << endl;

    for(int i = 0; i<k; i++) {
        int x, y;
        fin.read((char*)&x, sizeof(int));
        fin.read((char*)&y, sizeof(int));
        // cout << x << " " << y << endl;
        for(int j=0; j<m; j++){
            for(int l=0; l<m; l++){
                uint8_t temp;
                fin.read((char*)&temp, sizeof(uint8_t));
                matrix[x*m + j][y*m + l] = temp;
            }
        }
    }

    uint16_t **multiply_result = new uint16_t*[n];
    for(int i=0; i<n; i++){
        multiply_result[i] = new uint16_t[n];
    }

    double start,end;

    start = omp_get_wtime();
    multiply_simple_2D(matrix, multiply_result, n);
    end = omp_get_wtime();
    cout << "Simple 2D: " << end - start << endl;

    start = omp_get_wtime();
    multiply_with_transpose_2D(matrix, multiply_result, n);
    end = omp_get_wtime();
    cout << "Simple With Transpose 2D: " << end - start << endl;

    start = omp_get_wtime();
    mutiply_parallel_2D(matrix, multiply_result, n);
    end = omp_get_wtime();
    cout << "Parallel 2D: " << end - start << endl;

    start = omp_get_wtime();
    mutiply_parallel_with_transpose_2D(matrix, multiply_result, n);
    end = omp_get_wtime();
    cout << "Parallel With Transpose 2D: " << end - start << endl;
}

void input_1D(string input){
    ifstream fin(input, ios::binary);
    if (!fin) {
        std::cerr << "Error: unable to open input file." << std::endl;
        return ;
    }

    int  m, k;
    fin.read((char*)&n, sizeof(int));
    fin.read((char*)&m, sizeof(int));
    fin.read((char*)&k, sizeof(int));

    cout << n << " " << m << " " << k << endl;

    uint8_t* matrix;
    matrix = (uint8_t *)malloc(n*n*sizeof(uint8_t));
    matrix = (uint8_t *)memset(matrix, 0, n*n*sizeof(uint8_t));
    // cout << n*n << endl;

    for(int i = 0; i<k; i++) {
        int x, y;
        fin.read((char*)&x, sizeof(int));
        fin.read((char*)&y, sizeof(int));
        // cout << x << " " << y << endl;
        for(int j=0; j<m; j++){
            for(int l=0; l<m; l++){
                // cout << (x*m+j)*n + (y*m+l) << " ";
                fin.read((char*)&matrix[(x*m+j)*n + (y*m+l)], sizeof(uint8_t));
                // cout << (int)matrix[(x*m+j)*n + (y*m+l)] << " ";
            }
            // cout << endl;
        }
    }

    uint16_t multiply_result[n * n] = {0};

    double start = omp_get_wtime();
    multiply_simple(matrix, multiply_result, n);
    double end = omp_get_wtime();
    cout << "Simple: " << end - start << endl;

    start = omp_get_wtime();
    multiply_with_transpose(matrix, multiply_result, n);
    end = omp_get_wtime();
    cout << "Simple with transpose: " << end - start << endl;

    start = omp_get_wtime();
    mutiply_parallel(matrix, multiply_result, n);
    end = omp_get_wtime();
    cout << "Parallel: " << end - start << endl;

    start = omp_get_wtime();
    mutiply_parallel_with_transpose(matrix, multiply_result, n);
    end = omp_get_wtime();
    cout << "Parallel with transpose: " << end - start << endl;
}

class SparseMatrixArray {
public:
    int n;
    int len;
    vector<array<int,3>> data;

    SparseMatrixArray(int n){
        this->n = n;
        this->len = 0;
    };

    void insert(int r,int c,uint8_t value){
        array<int,3> temp;
        temp[0] = r;
        temp[1] = c;
        temp[2] = value;
        data.push_back(temp);
        len++;
    }

    void transpose(SparseMatrixArray &result){
        result.len = len;
        cout << result.len << endl;
        result.data.resize(len);
        for(int i=0; i<len; i++){
            result.data[i][0] = data[i][1];
            result.data[i][1] = data[i][0];
            result.data[i][2] = data[i][2];
        }
        // to count number of elements in each column
        int *count = new int[n + 1];
 
        // initialize all to 0
        for (int i = 1; i <= n; i++)
            count[i] = 0;
 
        for (int i = 0; i < len; i++){
            count[data[i][1]]++;
            // cout << data[i][1] << " " << count[data[i][1]] << endl;
        }

        // number of columns with atleast one non-zero element

 
        int *index = new int[n + 1];
 
        // to count number of elements having
        // col smaller than particular i
 
        // as there is no col with value < 0
        index[0] = 0;
 
        // initialize rest of the indices
        for (int i = 1; i <= n; i++)
 
            index[i] = index[i - 1] + count[i - 1];
 
        for (int i = 0; i < len; i++)
        {
 
            // insert a data at rpos and
            // increment its value
            int rpos = index[data[i][1]]++;
            // transpose row=col
            result.data[rpos][0] = data[i][1];
 
            // transpose col=row
            result.data[rpos][1] = data[i][0];
 
            // same value
            result.data[rpos][2] = data[i][2];
            cout << result.data[rpos][0] << " " << result.data[rpos][1] << " " << result.data[rpos][2] << endl;
        }
    }

    void multiply(SparseMatrixArray &b, SparseMatrixArray &result){
        SparseMatrixArray b_transpose(b.n);
        b.transpose(b_transpose);
        int apos, bpos;

        b_transpose=b;


        for (apos = 0; apos < len;)
        {
 
            // current row of result matrix
            int r = data[apos][0];
 
            // iterate over all elements of B
            for (bpos = 0; bpos < b_transpose.len;)
            {
 
                // current column of result matrix
                // data[,0] used as b_transpose is transposed
                int c = b_transpose.data[bpos][0];
 
                // temporary pointers created to add all
                // multiplied values to obtain current
                // element of result matrix
                int tempa = apos;
                int tempb = bpos;
 
                int sum = 0;
 
                // iterate over all elements with
                // same row and col value
                // to calculate result[r]
                while (tempa < len && data[tempa][0] == r &&
                       tempb < b_transpose.len && b_transpose.data[tempb][0] == c)
                {
                    if (data[tempa][1] < b_transpose.data[tempb][1])
 
                        // skip a
                        tempa++;
 
                    else if (data[tempa][1] > b_transpose.data[tempb][1])
 
                        // skip b_transpose
                        tempb++;
                    else
 
                        // same col, so multiply and increment
                        sum = Outer(Inner(data[tempa++][2],
                             b_transpose.data[tempb++][2]),sum);
                }
 
                // insert sum obtained in result[r]
                // if its not equal to 0
                if (sum != 0)
                    result.insert(r, c, sum);
 
                while (bpos < b_transpose.len &&
                       b_transpose.data[bpos][0] == c)
 
                    // jump to next column
                    bpos++;
            }
            while (apos < len && data[apos][0] == r)
 
                // jump to next row
                apos++;
        }

    }

};

void executeSparse(string input){
    ifstream fin(input, ios::binary);
    if (!fin) {
        std::cerr << "Error: unable to open input file." << std::endl;
        return ;
    }

    int  m, k;
    fin.read((char*)&n, sizeof(int));
    fin.read((char*)&m, sizeof(int));
    fin.read((char*)&k, sizeof(int));

    cout << n << " " << m << " " << k << endl;

    SparseMatrixArray matrix(n);
    // cout << n*n << endl;

    for(int i = 0; i<k; i++) {
        int x, y;
        fin.read((char*)&x, sizeof(int));
        fin.read((char*)&y, sizeof(int));
        for(int j=0; j<m; j++){
            for(int l=0; l<m; l++){
                uint8_t temp;
                fin.read((char*)&temp, sizeof(uint8_t));
                matrix.insert(x*m+j, y*m+l, temp);
            }
        }
    }

    SparseMatrixArray result(n);

    double start = omp_get_wtime();
    matrix.multiply(matrix, result);
    double end = omp_get_wtime();
    cout << "Sparse: " << end - start << endl;
}


int main(int argc, char *argv[]) {
    string input = argv[1];
    
    input_with_2D_array(input);
    input_1D(input);

    return 0;
}