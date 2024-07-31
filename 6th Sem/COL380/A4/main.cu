#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define TILE_SIZE 16
#define NUM_STREAMS 2

__global__ void sparse_matrix_mult(int *d_row_ptr, int *d_col_ind, short *d_val, short *d_A, short *d_B, short *d_C, int n)
{
    __shared__ short shared_A[TILE_SIZE][TILE_SIZE];
    __shared__ short shared_B[TILE_SIZE][TILE_SIZE];

    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int tx = threadIdx.x;
    int ty = threadIdx.y;

    short sum = 0;
    int start = d_row_ptr[row];
    int end = d_row_ptr[row+1];

    for (int k = start; k < end; k++) {
        int idx = d_col_ind[k];
        if (idx == col) {
            sum += d_val[k] * d_B[row * n + idx];
        }
        else {
            shared_A[ty][tx] = d_val[k];
            shared_B[ty][tx] = d_B[idx * n + col];
            __syncthreads();
            for (int i = 0; i < TILE_SIZE; i++) {
                sum += shared_A[ty][i] * shared_B[i][tx];
            }
            __syncthreads();
        }
    }

    d_C[row * n + col] = sum;
}

int main(int argc, char** argv)
{
    if (argc < 2) {
        printf("Usage: %s matrix.bin\n", argv[0]);
        exit(1);
    }

    char *filename = argv[1];
    FILE *fp = fopen(filename, "rb");

    if (fp == NULL) {
        printf("Error: could not open file %s\n", filename);
        exit(1);
    }

    int n;
    int num_blocks;
    int num_nonzeros;
    int block_size;
    int *row_ptr;
    int *col_ind;
    short *val;

    fread(&n, sizeof(int), 1, fp);
    fread(&num_blocks, sizeof(int), 1, fp);
    fread(&num_nonzeros, sizeof(int), 1, fp);
    fread(&block_size, sizeof(int), 1, fp);

    row_ptr = (int*)malloc((n+1) * sizeof(int));
    col_ind = (int*)malloc(num_nonzeros * sizeof(int));
    val = (short*)malloc(num_nonzeros * sizeof(short));

    fread(row_ptr, sizeof(int), n+1, fp);
    fread(col_ind, sizeof(int), num_nonzeros, fp);
    fread(val, sizeof(short), num_nonzeros, fp);

    fclose(fp);

    short *h_A = (short*)malloc(n * n * sizeof(short));
    short *h_B = (short*)malloc(n * n * sizeof(short));
    short *h_C = (short*)malloc(n * n * sizeof(short));

    for (int i = 0; i < n * n; i++) {
        h_A[i] = 0;
        h_B[i] = 0;
        h_C[i] = 0;
    }

    for (int i = 0; i < n; i += block_size) {
        for (int j = 0; j < n; j +=block_size) {
            int index = row_ptr[i / block_size];
            int next_index = row_ptr[(i / block_size) + 1];
            for (int k = index; k < next_index; k++) {
                int row = col_ind[k];
                int col = j + block_size - 1;
                if (col >= n) {
                    col = n - 1;
                }
                for (int r = i; r < i + block_size; r++) {
                    for (int c = j; c <= col; c++) {
                        h_A[r * n + c] = val[k];
                    }
                }
            }
        }
    }
    cudaMemcpy(d_A, h_A, n * n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_A, n * n * sizeof(float), cudaMemcpyHostToDevice);

    dim3 dimGrid(ceil((float)n/TILE_SIZE), ceil((float)n/TILE_SIZE), 1);
    dim3 dimBlock(TILE_SIZE, TILE_SIZE, 1);

    cudaStream_t streams[NUM_STREAMS];
    for (int i = 0; i < NUM_STREAMS; i++) {
        cudaStreamCreate(&streams[i]);
    }

    int chunk_size = n / NUM_STREAMS;
    for (int i = 0; i < NUM_STREAMS; i++) {
        int offset = i * chunk_size * n;
        int size = chunk_size * n;
        cudaMemcpyAsync(&d_B[offset], &h_B[offset], size * sizeof(float), cudaMemcpyHostToDevice, streams[i]);
        cudaMemcpyAsync(&d_C[offset], &h_C[offset], size * sizeof(float), cudaMemcpyHostToDevice, streams[i]);
    }

    for (int i = 0; i < NUM_STREAMS; i++) {
        int offset = i * chunk_size * n;
        sparse_matrix_mult<<<dimGrid, dimBlock, 0, streams[i]>>>(d_row_ptr, d_col_ind, d_val, d_A, &d_B[offset], &d_C[offset], n);
    }

    for (int i = 0; i < NUM_STREAMS; i++) {
        int offset = i * chunk_size * n;
        int size = chunk_size * n;
        cudaMemcpyAsync(&h_C[offset], &d_C[offset], size * sizeof(float), cudaMemcpyDeviceToHost, streams[i]);
    }

    cudaDeviceSynchronize();

    for (int i = 0; i < NUM_STREAMS; i++) {
        cudaStreamDestroy(streams[i]);
    }

    free(h_A);
    free(h_B);
    free(h_C);
    free(row_ptr);
    free(col_ind);
    free(val);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    cudaFree(d_row_ptr);
    cudaFree(d_col_ind);
    cudaFree(d_val);

    return 0;

}
