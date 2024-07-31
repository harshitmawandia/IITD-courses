# the compiler: gcc for C program, define as g++ for C++
  CC = gcc
 
  # compiler flags:
  #  -g     - this flag adds debugging information to the executable file
  #  -Wall  - this flag is used to turn on most compiler warnings
  CFLAGS  = -o
 
  # The build target 
  TARGET = a1
 
  all:
	g++ -I /usr/include/mkl mklMain.cpp -o ./yourcode1.out -fopenmp -lmkl_intel_lp64 -lmkl_core -lmkl_gnu_thread -lpthread -lm -ldl -pthread
	g++ -I /usr/include/x86_64-linux-gnu/openblas-pthread openblasMain.cpp -o ./yourcode2.out -fopenmp -lmkl_intel_lp64 -lmkl_core -lmkl_gnu_thread -lpthread -lm -ldl -pthread
