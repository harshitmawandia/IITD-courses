#include <iostream>
#include <cstdlib>
#include <pthread.h>
#include <bits/stdc++.h> 
#include <string>
#include <vector>
#include <math.h>
#include <fstream>
#include <thread>
#include "matrix.cpp"
#include "pthreads.cpp"

using namespace std;
using namespace std::chrono;

int main(int argc, char **args){

    int rowSize[] = {5,10,20,30,40,50,60,70,80,90,100};
    int colSize[] = {5,10,20,30,40,50,60,70,80,90,100};
    int means[11];
    int stdDevs[11];

    for(int i=0; i<11;i++){
        int sum =0;
        long long sqauresum =0;
        generateMatrix("matrix1.txt",rowSize[i],colSize[i]);
        generateMatrix("matrix2.txt",rowSize[i],colSize[i]);
        generateMatrix("matrix3.txt",rowSize[i],colSize[i]);
        for(int j=0;j<100;j++){
            auto start = high_resolution_clock::now();
            
            pthreadsMultiply("matrix1.txt","matrix2.txt","matrix3.txt","output3.txt");

            auto stop = high_resolution_clock::now();

            auto duration = duration_cast<microseconds>(stop - start);
        
            // cout << "Time taken by function: "<< duration.count() << " microseconds" << endl;

            sum+=duration.count();
            sqauresum+= duration.count()*duration.count();
        }
        double mean = sum/100;
        double stdDev = sqrt(sqauresum/100- mean*mean);
        means[i] =mean;
        stdDevs[i] = stdDev;
        cout << mean << endl;
        cout << stdDev << endl;
    }

    return 0;
}