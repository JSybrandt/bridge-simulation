CC=g++
CFLAGS=-std=c++11 -Wall -I /software/matlab/R2016a/extern/include/

TARGET=BridgeModel
SRCS=main.cpp
OBJS=$(SRCS:.cpp=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LIB)

.cpp.o: $<
	$(CC) $(CFLAGS) -c $< -o $@ $(LIB)

# input.o: input.cpp input.h
#		$(CC) $(CFLAGS) -c input.cpp

clean:
	rm *.o
	rm $(TARGET)

