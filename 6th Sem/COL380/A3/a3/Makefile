CC=mpicxx
CFLAGS=-std=c++11 -Wall -O3 -g -fopenmp

a2: main.o
	$(CC) $(CFLAGS) main.o -o a2

main.o: a2_parallel.cpp
	$(CC) $(CFLAGS) -c a2_parallel.cpp -o main.o

clean:
	rm a2 main.o
