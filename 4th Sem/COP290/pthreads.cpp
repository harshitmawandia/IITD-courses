#include <iostream>
#include <cstdlib>
#include <pthread.h>
#include <bits/stdc++.h> 
#include <string>
#include <vector>
#include <math.h>
#include <fstream>

using namespace std;
vector<vector<double>> A,B,C;
int row_Multiplied = 0;
int m,k,n;

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


vector<vector<double>> inputMatrix(string matrix, int &m, int &n){
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


void outputMatrix(vector<vector<double>> matrix, string output){
    ofstream fout;
    fout.open(output, ios::out | ios::trunc );

    int a,b;

    a = matrix.size();
    b = matrix[0].size();

    fout << b << "\n" << a << endl;

    for(int i=0;i<b;i++){
        for(int j=0;j<a;j++){
            fout << matrix[j][i] << endl;
            cout << matrix[j][i];
        }
        cout << endl;
    }

    fout.close();
}

void *multiply(void *threadid) {
    int i = row_Multiplied++;

    for(int j=0; j < n; j++){
        for(int p = 0; p<k; p++){
            C[i][j]+= A[i][k]*B[k][j];
        }
    }
}

void pthreadsMultiply(string matrix1,string matrix2,string matrix3, string output) {

    A = inputMatrix(matrix1,m,k);
    B = inputMatrix(matrix2,k,n);
    C = inputMatrix(matrix3,m,n);

    pthread_t threads[m];
    int i;
    
    for( i = 0; i < m; i++ ) {
        pthread_create(&threads[i], NULL, multiply, (void *)i); 
    }
    
    for (int i = 0; i < m; i++){
        pthread_join(threads[i], NULL); 
    }

    pthread_exit(NULL);

    outputMatrix(C,output);
    print(C);
}

int main(){

    pthreadsMultiply("matrix.txt","matrix.txt","matrix.txt","output1.txt");

    return 0;
}