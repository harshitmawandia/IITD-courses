CC = g++
CFLAGS = -Wall -std=c++11 -O3 -fopenmp 

exec:
	$(CC) $(CFLAGS) -o exec final.cpp -L. $(CURDIR)/library2.so
	export LD_LIBRARY_PATH=$(CURDIR):$(LD_LIBRARY_PATH)

.PHONY: run
run: exec
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd) && ./exec 

.PHONY: clean
clean:
	rm -f exec
