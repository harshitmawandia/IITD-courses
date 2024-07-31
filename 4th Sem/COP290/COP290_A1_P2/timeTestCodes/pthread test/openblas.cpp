#include <iostream>
#include <bits/stdc++.h> 
#include <string>
#include <vector>
#include <math.h>
#include <fstream>
#include <cblas.h>
#include <stdio.h>

using namespace std;

float* inputMatrixOB(int &a, int &b, string matrix){
    ifstream fin;
    fin.open(matrix);

    if(!fin.fail()){
        int temp;
        fin >> temp;
        b = temp;
        fin >> temp;
        a = temp;

        float* M = (float*) malloc(a*b*sizeof(float));

        for(int i=0;i<a*b;i++){
            float input;
            fin >> input;
            M[i] = input;
        }

        return M;
    }
}

void outputMatrixOB(int a, int b, float* matrix, string output){
    ofstream fout;
    fout.open(output, ios::out | ios::trunc );

    fout << b <<"\n"<< a << endl;
    for(int i=0;i<a*b;i++){
        fout << matrix[i] << endl;
    }

    fout.close();
}
void openBLASMultiply(string matrix1, string matrix2, string matrix3, string output){

    int m,k,n;

    float* A = inputMatrixOB(m,k,matrix1);
    float* B = inputMatrixOB(k,n,matrix2);
    float* C = inputMatrixOB(m,n,matrix3);


    cblas_sgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, A, m, B, k, 1.0, C, m);

    outputMatrixOB(m,n,C,output);
}
