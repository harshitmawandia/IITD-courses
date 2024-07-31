#include <iostream>
#include <bits/stdc++.h> 
#include <string>
#include <vector>
#include <math.h>
#include <fstream>
#include "mkl.h"

using namespace std;

double* inputMatrix(int &a, int &b, string matrix){

    ifstream fin;
    fin.open(matrix);

    if(!fin.fail()){
        int temp;
        fin >> temp;
        b = temp;
        fin >> temp;
        a = temp;

        double* M = (double*) mkl_malloc(a*b*sizeof(double),64);

        for(int i=0;i<a*b;i++){
            double input;
            fin >> input;
            M[i] = input;
        }

        return M;
    }
}

void outputMatrix(int a, int b, double* matrix, string output){
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

    double* A = inputMatrix(m,k,matrix1);
    double* B = inputMatrix(k,n,matrix2);
    double* C = inputMatrix(m,n,matrix3);

    // cout << m<<k<<n << endl;


    cblas_dgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, m, k, n, 1.0, A, m, B, k, 1.0, C, m);

    outputMatrix(m,n,C,output);
}
