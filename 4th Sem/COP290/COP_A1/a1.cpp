#include <iostream>
#include <bits/stdc++.h> 
#include <string>
#include <vector>
#include <math.h>
#include <fstream>

using namespace std;

struct bad_value : public std::exception { };

void print(vector<vector<double>> A){
    int a = A.size();
    int b = A[0].size();

    for (int i = 0; i < a; i++)
    {
        for (int j = 0; j < b; j++)
        {
            cout << A[i][j] << " ";
        }
        cout << endl;
    }
}


vector<vector<double>> inputMatrix(string matrix){
    ifstream fin;
    fin.open(matrix);

    if(!fin.fail()){
        int a,b;

        fin >> b;
        fin >> a;

        vector<vector<double>> A;

        for(int i=0; i<a;i++){
            vector<double> temp;
            A.push_back(temp);
        }

        for(int i=0;i<b;i++){
            for(int j=0;j<a;j++){
                double temp;
                fin >> temp;
                A[j].push_back(temp);
            }
        }

        fin.close();

        return A;
    }else{
        cout << "File not found" << endl;
        std:: exit;
        vector<vector<double>> a;
        return a;
    }

}

vector<double> inputVector(string vec){
    ifstream fin;
    fin.open(vec);

    if(!fin.fail()){

        int a;

        fin >> a;

        vector<double> A;

        for(int i=0; i<a;i++){
            double temp;
            fin >> temp;
            A.push_back(temp);
        }

        fin.close();

        return A;
    }else{
        cout << "File not found" << endl;
        std:: exit;
        vector<double> a;
        return a;
    }
}

void outputMatrix(vector<vector<double>> matrix, string output){
    ofstream fout;
    fout.open(output, ios::out | ios::trunc );

    int a,b;

    a = matrix.size();
    b = matrix[0].size();

    fout << b << "\n" << a << endl;

    for(int i=0;i<b;i++){
        for(int j=0;j<a;j++){
            fout << matrix[j][i] << endl;
        }
    }

    fout.close();
}

void outputvector(vector<double> vec, string output){
    ofstream fout;
    fout.open(output, ios::out | ios::trunc );

    int a;

    a = vec.size();

    fout << a << endl;

    for(int i=0;i<a;i++){
        fout << vec[i] << endl;
    }

    fout.close();

}

vector<vector<double>> matrixMultiply(vector<vector<double>> A, vector <vector<double>> B, int a, int b, int c){
    vector<vector<double>> C;
    for(int i=0; i< a; i++){
        vector<double> temp;
        for(int j=0;j<c; j++){
            double sum=0;
            for(int k=0;k<b;k++){
                sum+= A[i][k]*B[k][j];
            }
            temp.push_back(sum);
        }
        C.push_back(temp);
    }

    return C;
}

vector<vector<double>> matrixAddition(vector<vector<double>> A, vector<vector<double>> B, int a, int b){
    vector<vector<double>> C;
    for(int i=0; i< a; i++){
        vector<double> temp;
        for(int j=0;j<b; j++){
            double sum = A[i][j]+B[i][j];
            temp.push_back(sum);
        }
        C.push_back(temp);
    }

    return C;
}


void fullyConnected(string matrix1,string matrix2,string matrix3, string output){
    vector<vector<double>> A = inputMatrix(matrix1);
    vector<vector<double>> B = inputMatrix(matrix2);
    vector<vector<double>> C = inputMatrix(matrix3);
    int a = A.size();
    int b = A[0].size();
    int c = B[0].size();
    if(b==B.size() && a==C.size() && c==C[0].size()){
    vector<vector<double>> AB = matrixMultiply(A,B,a,b,c);
    vector<vector<double>> AXC = matrixAddition(AB,C,a,c);
    outputMatrix(AXC,output);
    }else{
        cout << "Dimensions of matrix are not compatbile with each other" << endl;
    }
}

vector<vector<double>> relu(vector<vector<double>> A){
    int a = A.size();
    int b = A[0].size();

    for(int i = 0;i<a;i++){
        for(int j=0;j<b;j++){
            double temp = A[i][j];
            if(temp<0){
                A[i][j]=0;
            }
        }
    }

    return A;
}

double tanhM(double x){
    double a = exp(x) - exp(-x);
    double b = exp(x) + exp(-x);
    return a/b;
}

vector<vector<double>> matrixTanh(vector<vector<double>> A){
    int a = A.size();
    int b = A[0].size();

    vector<vector<double>> B;

    for(int i = 0;i<a;i++){
        vector<double> t;
        for(int j=0;j<b;j++){
            double temp = tanhM(A[i][j]);
            t.push_back(temp);
        }
        B.push_back(t);
    }

    return B;
}

void a2(string t, string matrix, string output){

    vector<vector<double>> A = inputMatrix(matrix);

    vector<vector<double>> B;

    if (t.compare("relu")==0){
        B = relu(A);
    }else if(t.compare("tanh")==0){
        B = matrixTanh(A);
    }else {
        cout << "Invalid acitivation choice, try again with relu or tanh" << endl;
    }

    outputMatrix(B,output);
}

vector<vector<double>> maxPooling(vector<vector<double>> A, int b){
    if(b==0){
        throw 555;
    }
    int n = A.size();
    int N;
    if(1.0f*n/b == floor(n/b)){
        N = n/b;
    }else{
        throw 666;
    }

    vector<vector<double>> B;

    for(int i = 0; i < N; i++){
        vector<double> temp;
        for(int j =0; j < N; j++){
            double maxT = -DBL_MAX;
            for(int k = b*i; k < b*i + b; k++){
                for (int l = b*j; l < b*j + b;l++){
                    if(max(maxT,A[k][l])!=maxT){
                        maxT=A[k][l];
                    }
                }
            }
            temp.push_back(maxT);
        }
        B.push_back(temp);
    }

    return B;
}

vector<vector<double>> averagePooling(vector<vector<double>> A, int b){
    if(b==0){
        throw 555;
    }
    int n = A.size();
    int N ;
    if(1.0f*n/b == floor(1.0f*n/b)){
        N = n/b;
    }else{
        throw 666;
    }
    

    vector<vector<double>> B;

    for(int i = 0; i < N; i++){
        vector<double> temp;
        for(int j =0; j < N; j++){
            double sum = 0;
            for(int k = b*i; k <b*i + b; k++){
                for (int l = b*j; l < b*j + b;l++){
                    sum+= A[k][l];
                }
            }
            sum = sum/(b*b);
            temp.push_back(sum);
        }
        B.push_back(temp);
    }

    return B;
}

void a3(string t, string matrix, int b, string output){
    vector<vector<double>> A = inputMatrix(matrix);

    vector<vector<double>> B;

    if (t.compare("max")==0){
        B = maxPooling(A,b);
    }else if(t.compare("average")==0){
        B = averagePooling(A,b);
    }else {
        cout << "Invalid pooling choice, try again with max or average" << endl;
    }

    outputMatrix(B,output);
}

vector<double> sigmoid(vector<double> A){
    int n = A.size();

    vector<double> B;

    for(int i =0; i< n;i++){
        double temp;
        temp = 1/(1+exp(-A[i]));
        B.push_back(temp);
    }

    return B;
}

vector<double> softMax(vector<double> A){
    int n = A.size();

    vector<double> B;

    double sum=0;

    for(int i =0; i< n;i++){
        sum+=exp(A[i]);
    }

    for(int i =0; i< n;i++){
        double temp;
        temp = exp(A[i])/sum;
        B.push_back(temp);
    }

    return B;
}

void a4(string t, string vec, string output){
    vector<double> A = inputVector(vec);

    vector<double> B;

    if (t.compare("sigmoid")==0){
        B = sigmoid(A);
    }else if(t.compare("softmax")==0){
        B = softMax(A);
    }else {
        cout << "Invalid probability choice, try again with sigmoid or softmax" << endl;
    }

    outputvector(B,output);
}


int main(int argc, char **args){
    string s ;
    if(argc > 2){
        s = args[1];
    }else{
        cout << "Incorrect Arguments" << endl;
        return 0;
    }

    if(s.compare("fullyconnected")==0){
        if (argc ==6){
            fullyConnected(args[2],args[3],args[4],args[5]);
        }else {
            cout << "Incorrect Arguments" << endl;
        }
    }else if(s.compare("activation")==0){
        if(argc==5){
            a2(args[2],args[3],args[4]);
        }else {
            cout << "Incorrect Arguments" << endl;
        }
    }else if(s.compare("pooling")==0){
        try{
            if(argc==6){
                a3(args[2],args[3],atoi(args[4]),args[5]);
            }else {
                cout << "Incorrect Arguments" << endl;
            }
        }catch(int a){
            if(a==555){
                cout << "Stride needs to be a poistive integer" << endl;
            }else if(a=666){
                cout << "Stride does not divide Matrix dimensions" << endl;
            }
        }
    }else if(s.compare("probability")==0){
        if(argc==5){
            a4(args[2],args[3],args[4]);
        }else{
            cout << "Incorrect Arguments" << endl;
        }
    }else{
        cout << "Invalid Function Choice" << endl;
    }

    return 0;
}