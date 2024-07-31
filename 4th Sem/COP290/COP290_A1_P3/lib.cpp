#include "lib.h"

pred_t* libaudioAPI(const char* audiofeatures, pred_t* pred){

    float W1[250*144] = IP1_WT;//float array W1 stores weight1 in rowmajor order
    float Bias1[144] = IP1_BIAS;//float array Bias1 stores Bias1 in rowmajor order

    float* W1Pointer = W1;
    float* Bias1Pointer = Bias1;

    string filename = audiofeatures;

    float* input;
    try{
        input = readMatrix(1,250,filename);//taking 1x250 feature vector as input
    }catch (...){
        throw "Division by zero condition!";
    }
    
    // cout << input[0] << endl;

    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, 1, 144, 250, 1.0, input, 250, W1Pointer, 144, 1.0, Bias1Pointer, 144);//FC1 [250x144] 

    Bias1Pointer = relu(Bias1Pointer,144);//RELU

    float W2[144*144] = IP2_WT; //float array W2 stores weight2 in rowmajor order
    float Bias2[144] = IP2_BIAS;//float array Bias2 stores Bias2 in rowmajor order

    float* W2Pointer = W2;
    float* Bias2Pointer = Bias2;

    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, 1, 144, 144, 1.0, Bias1Pointer, 144, W2Pointer, 144, 1.0, Bias2Pointer, 144);//FC2 [144x144] 

    Bias2Pointer = relu(Bias2Pointer,144);//RELU

    float W3[144*144] = IP3_WT;//float array W3 stores weight3 in rowmajor order
    float Bias3[144] = IP3_BIAS;//float array Bias3 stores Bias3 in rowmajor order


    float* W3Pointer = W3;
    float* Bias3Pointer = Bias3;

    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, 1, 144, 144, 1.0, Bias2Pointer, 144, W3Pointer, 144, 1.0, Bias3Pointer, 144);//FC3 [144X144] 

    Bias3Pointer = relu(Bias3Pointer,144);//RELU

    float W4[144*12] = IP4_WT; //float array W4 stores weight4 in rowmajor order
    float Bias4[12] = IP4_BIAS;//float array Bias4 stores Bias4 in rowmajor order


    float* W4Pointer = W4;
    float* Bias4Pointer = Bias4;

    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, 1, 12, 144, 1.0, Bias3Pointer, 144, W4Pointer, 12, 1.0, Bias4Pointer, 12); //FC4 [144x12]

    Bias4Pointer = softmax(Bias4Pointer, 12);//softmax.

    int index[12] = {0,1,2,3,4,5,6,7,8,9,10,11};

    pairsort(Bias4Pointer, index, 12); //sorting  probabilty vector and arranging index vector accordingly

    pred_t pred_tArr[3];
    pred = pred_tArr;

    for(int i =9; i <12; i++){
        pred_t temp;
        temp.label = index[i];
        temp.prob = Bias4Pointer[i];
        pred_tArr[i-9] = temp; 
    }

    return pred;
}