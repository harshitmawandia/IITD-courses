#include <iostream>
#include <bits/stdc++.h> 
#include <fstream>
#include "matrix.cpp"
#include "pthreads.cpp"


// #include "a1.cpp"

using namespace std;
using namespace std::chrono;


int main(int argc, char **args){
    ofstream f;
    f.open ("pthreadtiming.txt");
    int rowSize[] = {5,10,20,30,40,50,60,70,80,90,100,200,300,400};
    int colSize[] = {5,10,20,30,40,50,60,70,80,90,100,200,300,400};
    int means[14];
    int stdDevs[14];

    for(int i=0; i<14;i++){
        long long sum =0;
        long long sqauresum =0;
        generateMatrix("matrix1.txt",rowSize[i],colSize[i]);
        generateMatrix("matrix2.txt",rowSize[i],colSize[i]);
        generateMatrix("matrix3.txt",rowSize[i],colSize[i]);
        for(int j=0;j<100;j++){
            auto start = high_resolution_clock::now();
            
            pthreadsMultiply("matrix1.txt","matrix2.txt","matrix3.txt","output2.txt");

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
        f <<  rowSize[i] << std::setw(10) << means[i] << std::setw(10) << stdDevs[i]<<"\n";
        cout <<  rowSize[i] << std::setw(10) << means[i] << std::setw(10) << stdDevs[i]<<"\n";
    }
    return 0;
}
