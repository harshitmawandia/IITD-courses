#include <iostream>
#include <bits/stdc++.h> 
#include <string>
#include <vector>
#include <math.h>
#include <fstream>

using namespace std;


void generateMatrix(string filename, int n, int m){
    srand (static_cast <unsigned> (time(0)));

    ofstream fout;

    fout.open(filename, ios::out | ios::trunc );

    fout << m <<"\n"<< n << endl;

    cout << "hello" << endl;

    for(int i=0;i<n*m;i++){
        double r2 = static_cast <float> (rand()) / (static_cast <float> (RAND_MAX/2000.0));
        fout << r2 << endl;
    }

    fout.close();
}
