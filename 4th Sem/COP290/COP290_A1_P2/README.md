
# Task 1: Subtask 2

Warming up to compiling and debugging some C++ functions:

## Steps to run the program

1. type _make_ on the command line.
> It compiles all the code of the directory. 
  mklMain.cpp is converted to executable: yourcode1.out 
  openblasMain.cpp is converted to execuatble: yourcode2.out 

2. We have 3 implementation choices of the fullyconnected function:

    a. mkl

    b. openblas

    c. pthreads

3. The code format for each is given below:

    a. _./yourcode1.out fullyconnected inputmatrix.txt weightmatrix.txt biasmatrix.txt outputmatrix.txt mkl_

    b.  _./yourcode1.out fullyconnected inputmatrix.txt weightmatrix.txt biasmatrix.txt outputmatrix.txt pthread_

    c. _./yourcode2.out fullyconnected inputmatrix.txt weightmatrix.txt biasmatrix.txt outputmatrix.txt openblas_

    d. _./yourcode2.out fullyconnected inputmatrix.txt weightmatrix.txt biasmatrix.txt outputmatrix.txt pthread_


4. Type the necessary code format in the command line to execute.

## Measuring Latency
1. The timings of the above three implementation are in jpg and eps files as boxplots with errorbars. 
2. Randomly generated matrices of sizes ranging from 10 to 400 were taken as input. 
3. Mean and SD of 100 iterations were plotted for each size using gnuplot script.

