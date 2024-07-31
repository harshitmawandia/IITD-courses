CC := nvcc
CFLAGS := -O3 -std=c++11 -arch=sm_35 -code=sm_35,compute_35

TARGET := exec
SRC := main.cu

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)
