MKL_BLAS_PATH = /opt/intel/oneapi/mkl/2022.0.0
GCC_COMPILER_FLAGS = -std=c++17 ${MKL_BLAS_PATH}/lib/libmkl_intel_lp64.a ${MKL_BLAS_PATH}/lib/libmkl_tbb_thread.a ${MKL_BLAS_PATH}/lib/libmkl_core.a -L${TBBROOT}/lib -ltbb -lc++ -lpthread -lm     -ldl 
all:
	g++ lib.cpp -fpic -c ${GCC_COMPILER_FLAGS}
	g++ -shared -o libaudio.so lib.o ${GCC_COMPILER_FLAGS}
	g++ -laudio -o yourcode.out -L{LD_LIBRARY_PATH}