#include <iostream>
#include <bits/stdc++.h> 
#include <fstream>
#include "openblas.cpp"
#include "pthreads.cpp"

using namespace std;
using namespace std::chrono;


int main(int argc, char **args){
    
    
    string s=args[1];
    try{
        if(s.compare("fullyconnected")==0){
            string type = args[6];
            if(type.compare("openblas")==0){
                openBLASMultiply(args[2],args[3],args[4],args[5]);
            }else if(type.compare("pthread")==0){
                pthreadsMultiply(args[2],args[3],args[4],args[5]);
            }else {
                cerr<<"wrong argument"<<endl;
            }
        }
    } catch(...){
        cout << "Wrong inputs" << endl;
    }
    return 0;
}
