#include <iostream>
#include "lib.h"
#include <vector>
#include <string>
#include <fstream>

using namespace std;

string WORDS[12] = {"silence", "unknown", "yes", "no", "up", "down", "left", "right", "on", "off", "stop", "go"};//array to map index to word

int main(int argc, char **args){
    
    string filename = args[1];
    string output = args[2];

    pred_t* p;
    try{
        p = libaudioAPI(filename.c_str(),p);
        string words="";
        float f[3];

        for(int i=0;i<3;i++){
            words = WORDS[p->label] + " " + words;
            f[i] = p->prob;
            p++;
        }

        ofstream fout;

        fout.open(output, ios::app);

        fout << filename << " " << words << f[2] << " " << f[1] << " " << f[0] << endl;

        fout.close();

    }catch (...){
        cout << "File not found" << endl;
    }
    

    
    return 0;
}