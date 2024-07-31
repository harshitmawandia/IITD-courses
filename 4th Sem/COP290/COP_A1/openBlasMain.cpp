#include <iostream>
#include <bits/stdc++.h> 
#include <fstream>
#include "openblas.cpp"
#include "pthreads.cpp"
#include "matrix.cpp"

// #include "a1.cpp"

using namespace std;
using namespace std::chrono;


int main(int argc, char **args){
    
    auto start = high_resolution_clock::now();
    string s=args[1];
    if(s.compare("fullyconnected")==0){
        string type = args[6];
        if(type.compare("openblas")==0){
            openBLASMultiply(args[2],args[3],args[4],args[5]);
        }else if(type.compare("pthread")==0){
            pthreadsMultiply(args[2],args[3],args[4],args[5]);
        }else {
            // fullyConnected(args[2],args[3],args[4],args[5]);
        }
    }
    auto stop = high_resolution_clock::now();

    auto duration = duration_cast<microseconds>(stop - start);
  
    cout << "Time taken by function: "
         << duration.count() << " microseconds" << endl;

    return 0;
}