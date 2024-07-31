CC=mpicxx
CFLAGS=-std=c++11 -Wall -O3 -g -fopenmp

a3: main.o
	$(CC) $(CFLAGS) main.o -o a3

main.o: a2_parallel.cpp
	$(CC) $(CFLAGS) -c a2_parallel.cpp -o main.o

clean:
	rm a3 main.o
