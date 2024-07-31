#include <iostream>
#include <cstdlib>
#include <pthread.h>
#include <bits/stdc++.h> 
#include <string>
#include <vector>
#include <math.h>
#include <fstream>
#include <thread>

unsigned int nthreads = std::thread::hardware_concurrency();

using namespace std;
using namespace std::chrono;
vector<vector<double>> A,B,C;
int row_Multiplied = 0;
int m,k,n;

pthread_mutex_t lock1 = PTHREAD_MUTEX_INITIALIZER;

struct thread_args{
    int start;
    int end;
};

void print(vector<vector<double>> A){
    int a = A.size();
    int b = A[0].size();

    for (int i = 0; i < a; i++)
    {
        for (int j = 0; j < b; j++)
        {
            cout << A[i][j] << " ";
        }
        cout << endl;
    }
}


vector<vector<double>> inputMatrixP(string matrix, int &m, int &n){
    ifstream fin;
    fin.open(matrix);

    if(!fin.fail()){
        int a,b;

        fin >> b;
        fin >> a;

        m=a;
        n=b;

        vector<vector<double>> A;

        for(int i=0; i<a;i++){
            vector<double> temp;
            A.push_back(temp);
        }

        for(int i=0;i<b;i++){
            for(int j=0;j<a;j++){
                double temp;
                fin >> temp;
                A[j].push_back(temp);
            }
        }

        fin.close();

        return A;
    }else{
        cout << "File not found" << endl;
        std:: exit;
        vector<vector<double>> a;
        return a;
    }

}


void outputMatrixP(vector<vector<double>> matrix, string output){
    ofstream fout;
    fout.open(output, ios::out | ios::trunc );

    int a,b;

    a = matrix.size();
    b = matrix[0].size();

    fout << b << "\n" << a << endl;

    for(int i=0;i<b;i++){
        for(int j=0;j<a;j++){
            fout << matrix[j][i] << endl;
            // cout << matrix[j][i];
        }
        // cout << endl;
    }

    fout.close();
}

void *multiply(void *args) {
    struct thread_args * range = (struct thread_args *) args;
    int x = row_Multiplied++;
    int t = (((m-1)/nthreads)+1);
    // cout << t*(x) <<endl;
    for(int i=0; i<m;i++){     
        // cout << i << endl;   
        for(int j=0; j < n; j++){
            double d = 0;
            for(int p = range->start; p < range->end; p++){
                d+= A[i][p]*B[p][j];
            }
            pthread_mutex_lock(&lock1);
            C[i][j]+=d;
            pthread_mutex_unlock(&lock1);
        }
    }
}

void pthreadsMultiply(string matrix1,string matrix2,string matrix3, string output) {

    A = inputMatrixP(matrix1,m,k);
    B = inputMatrixP(matrix2,k,n);
    C = inputMatrixP(matrix3,m,n);

    pthread_t threads[min((int)nthreads,m)];
    struct thread_args work_ranges[min((int)nthreads,m)];
    int current_start, range;
    current_start = 0;
    range = k / min((int)nthreads,m);

    
    for(int i = 0; i < min((int)nthreads,m); i++) {
        work_ranges[i].start = current_start;
        work_ranges[i].end = current_start + range;
        current_start += range;
    }

    for(int i = 0; i < min((int)nthreads,m); i++ ) {
        pthread_create(&threads[i], NULL, multiply, &work_ranges[i]);
    }
    
    for (int i = 0; i < min((int)nthreads,m); i++){
        pthread_join(threads[i], NULL); 
        
    }
    
    outputMatrixP(C,output);
}
