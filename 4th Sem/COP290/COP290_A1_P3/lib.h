#ifndef lib_h__
#define lib_h__
#include "fun.cpp"
// #include "lib.cpp"

typedef struct{
    int label;
    float prob;
}pred_t;

extern pred_t* libaudioAPI(const char* audiofeatures, pred_t* pred);

#endif  