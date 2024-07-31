#include <iostream>
#include <fstream>
#include <string>
#include "mkl.h"
#include "dnn_weights.h" //header file containing weights and bias matrices
#include <math.h>
#include <algorithm>
// #include "lib.h"

using namespace std;


float* readMatrix(int a, int b, string matrix){ //takes matrix input from .txt file and returns pointer to corresponding array
    ifstream fin;
    fin.open(matrix);

    if(!fin.fail()){
        float* M = (float*) mkl_malloc(a*b*sizeof(float),64); //allocating space to matrix

        for(int i=0;i<a*b;i++){ //loop to take input
            float input;
            fin >> input;
            M[i] = input;
        }

        return M;
    }else{
        throw "Division by zero condition!";
    }
}

float* relu(float* matrix,  int n){         // takes pointer to the matrix and size n, returns  pointer to matrix with relu applied to each element
    float* M = (float*) malloc(n*sizeof(float)); //allocating space to matrix
    M = matrix;
    for(int i=0;i<n;i++){   //applying relu to each element
        if (M[i]<0)     
            M[i]=0;
    }
    return M;
}

float* softmax(float* vec, int m){       // takes pointer to the vector and size m, returns  pointer to matrix with softmax applied to each element
    double sum=0;
    float* V = (float*) malloc(m*sizeof(float)); //allocating space to vector
    V=vec;
    for(int i=0;i<m;i++)
        sum+= exp(V[i]);        //applying softmax to each element
    for(int i=0;i<m;i++)
        V[i]=(exp(V[i])/sum);

    return V;
}

void pairsort(float a[], int b[], int n) //function to sort array 'a' and arrange the index array 'b'accordingly
{
    pair<float, int> pairt[n];
  
    // Storing the respective array
    // elements in pairs.
    for (int i = 0; i < n; i++) 
    {
        pairt[i].first = a[i];
        pairt[i].second = b[i];
    }
  
    // Sorting the pair array.
    sort(pairt, pairt + n);
      
    // Modifying original arrays
    for (int i = 0; i < n; i++) 
    {
        a[i] = pairt[i].first;
        b[i] = pairt[i].second;
    }
}

