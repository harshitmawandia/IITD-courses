#include <iostream>
#include <bits/stdc++.h> 
#include <string>
#include <vector>
#include <math.h>
#include <fstream>
#include "cblas.h"
#include <stdio.h>

using namespace std;

double* inputMatrixOB(int &a, int &b, string matrix){
    ifstream fin;
    fin.open(matrix);

    if(!fin.fail()){
        int temp;
        fin >> temp;
        b = temp;
        fin >> temp;
        a = temp;

        double* M = (double*) malloc(a*b*sizeof(double));

        for(int i=0;i<a*b;i++){
            double input;
            fin >> input;
            M[i] = input;
        }

        return M;
    }
}

void outputMatrixOB(int a, int b, double* matrix, string output){
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

    // cout << "hello" << endl;

    double* A = inputMatrixOB(m,k,matrix1);
    double* B = inputMatrixOB(k,n,matrix2);
    double* C = inputMatrixOB(m,k,matrix3);


    cblas_dgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, A, k, B, n, 1.0, C, n);

    outputMatrixOB(m,n,C,output);
}