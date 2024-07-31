Sparse Matrix Multiplication using OpenMP

We have implemented various matrix multiplication algorithms in the past. 
In this post, we will implement a sparse matrix multiplication algorithm using OpenMP.

Sparse Matrix Multiplication
The sparse matrix multiplication algorithm is a special case of the matrix multiplication algorithm.
We are using sparsity of the matrix to reduce the number of operations in the matrix multiplication algorithm.
We store the non-zero blocks of the matrix in 2D arrays. We only multiply the non-zero blocks of the matrix.

Sparse Matrix Multiplication Algorithm
1. Initialize the result matrix with 0.
2. Take transpose of the second matrix.
3. For each row of the first matrix:
    3.1. For each row of the transpose of the second matrix:
        Initialize a temporary block with 0.
        3.1.1. For each block of the first matrix row:
            Check if the block is non-zero and the corresponding block in the second matrix row is non-zero.
            If yes, multiply the blocks and add the result to the corresponding temp block.
        3.1.2. If the temp block is non-zero, add it to the result matrix.
4. Return the result matrix.

Sparse Matrix Multiplication using OpenMP
We will implement the sparse matrix multiplication algorithm using OpenMP.
We will use the same matrix multiplication algorithm as in the previous post.
We parallelize the outer loop of the sparse matrix multiplication algorithm.
We specify the critical section for the result matrix where we add the temp block to the result matrix.

Steps to Compile and Run the Program: 
1. Ensure that you have final.cpp, library.so, input , library.hpp and Makefile in the same directory.
2. Run the following command to compile and run the program:
    make
    ./exec inputFile outputFile    #inputFile is the input file and outputFile is the output file.

Output:
The output of the program is stored in the output file.

For all the other approaches, we have code in the files:
1. A1.cpp
2. A2.cpp
3. sparse.cpp

Details of all the approaches:

Approach 1
Idea: Standard Matrix Multiplication of two Dense Matrix of the O(n^3)
Why: To start off with a standard approach to see how much time it takes as a base case.
Results: We see that this approach is quite inefficient as n grows. Speedup = 1
Drawbacks: Inefficient Approach with a lot of cache misses and no parallelization.

Approach 2
Idea: Reduce Cache misses by taking transpose of second matrix.
Why: Normal approach has a lot of Cache Misses and we want to optimise them.
Results: We see that this approach is quite inefficient as n grows. Speedup = 1.2
Drawbacks: We do not make use of parallelization as well as the sparsity of the matrix

Approach 3
Idea: Paralled Matrix Multiplication of two Dense Matrix of the O(n3)
Why: To start how parallelization effects the speedup
Results: This approach reduces the time taken by ratio of the number of threads that we use for larger
matrices Speedup Depends on number of threads (Usually 0.5*(Number of Threads) for large matrices)
Drawbacks: We still do not make use of the sparsity of the matrix and there are a lot of cache misses.

Approach 4
Idea: Parallel Matrix Multiplication along with transpose of the second matrix
Why: To see how threads react when cache misses are reduced
Results: The time taken reduces significantly in this approach although the order does not change, this method still doesn’t work for large sparse matrices. Speedup Depends on number of threads (Usually 0.62*(Number of Threads) for large matrices)
Drawbacks: Doesn’t make use of the sparsity of the matrix, does unnecessary calculations. Gives Segmentation faults for large matrices

Approach 5
Idea: To use a 1D array to store matrix in row-major order along with parallelization and transposing
Why: Since for large matrices, we can’t handle large arrays, and there are segmentation faults
Results: We see that this approach removes any segmentation faults that occurred earlier due to large 2D matrices. Speedup = Same as Approach 4
Drawbacks: Doesn’t make use of Sparse matrices

Approach 6
Idea: Using sparse Matrix multiplication without multiple threads, Storing elements in a linked list
Why: To make use of the sparsity of the matrix and see how it scales without multi-threading
Results: We see that this approach reduces the time significantly for large matrices. Speedup = 3.2
Drawbacks: It takes a lot of time to iterate the linked list to find the desired row

Approach 7
Idea: Using sparse Matrix multiplication without multiple threads, Storing elements in a Hashmap
Why: To reduce the time taken in iterating the linked list
Results: This approach improves the efficiency of the algorithm. Speedup = 3.4
Drawbacks: We are not using parallelization

Approach 8
Idea: Using sparse Matrix multiplication with multiple threads, Storing elements in a Hashmap
Why: To divide the work equally among multiple threads and see the result
Results: This approach improves the efficiency of the algorithm significantly. Speedup = 3.2 * (Num of Threads)
Drawbacks: The matrix should not contain a very large number of non-zero elements, introduces an extra factor of O(log(n)) to search for the corresponding element in the second matrix

Final Approach: Approach 9
Idea: Using sparse Matrix multiplication with multiple threads, Storing elements in a 2D vector of Blocks of size (m x m)
Why: We can reduce the time complexity by O(log(n)) from the hashmap implementation. Also, we see that by storing elements in a block, we reduce the time complexity of the Matrix Multiplication of the Sparse Matrix by a factor of approximately 2.3 for larger matrices and block sizes
Results: This approach improves the time taken to for the input2 file from around 60 sec to around 10 sec for 8 threads. Speedup = 14.4 * (Num of Threads)
Drawbacks: The algorithm is quite efficient and scales quite nicely with more threads and a larger input file.

Submissions:

2020CS10348_A1/
|-- Makefile
|-- readme.txt
|-- task.pdf
|-- final.cpp
|-- library.so
|-- library.hpp
|-- library2.so
|-- A1.cpp
|-- A2.cpp
|-- sparse.cpp
|-- table.csv
