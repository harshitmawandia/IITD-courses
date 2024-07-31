#include <iostream>
#include <bits/stdc++.h> 
#include <string>
#include <vector>
#include <math.h>
#include <fstream>
#include "mkl.h"

using namespace std;

float* inputMatrix(int &a, int &b, string matrix){

    ifstream fin;
    fin.open(matrix);

    if(!fin.fail()){
        int temp;
        fin >> temp;
        b = temp;
        fin >> temp;
        a = temp;

        float* M = (float*) mkl_malloc(a*b*sizeof(float),64);

        for(int i=0;i<a*b;i++){
            float input;
            fin >> input;
            M[i] = input;
        }

        return M;
    }
}

void outputMatrix(int a, int b, float* matrix, string output){
    ofstream fout;
    fout.open(output, ios::out | ios::trunc );

    fout << a <<"\n"<< b << endl;

    for(int i=0;i<a*b;i++){
        fout << matrix[i] << endl;
    }

    fout.close();
}

void mklMultiply(string matrix1, string matrix2, string matrix3, string output){

    int m,k,n;

    float* A = inputMatrix(m,k,matrix1);
    float* B = inputMatrix(k,n,matrix2);
    float* C = inputMatrix(m,n,matrix3);

    // cout << m<<k<<n << endl;

    cblas_sgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, A, m, B, k, 1.0, C, m);

    outputMatrix(m,n,C,output);
}
