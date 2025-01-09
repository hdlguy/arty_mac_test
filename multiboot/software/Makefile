ALL_EXE = loop rate_test tx_test
all: $(ALL_EXE) 

CC=gcc
CFLAGS=-I. -Wall

DEPS = Makefile ./fpga.h

PUBLIC_LIBS = 
LIB_FILES =

LIB_OBJS := $(subst .c,.o,$(LIB_FILES))

loop: loop.o $(LIB_OBJS) $(PUBLIC_LIBS)
# $@: target file name, $^: all prerequisites, $<: first prerequisite
	gcc -g -o $@ $^

rate_test: rate_test.o $(LIB_OBJS) $(PUBLIC_LIBS)
	gcc -g -o $@ $^

tx_test: tx_test.o $(LIB_OBJS) $(PUBLIC_LIBS)
	gcc -g -o $@ $^

clean:
	rm -rf *.o $(ALL_EXE) 

%.o: %.c $(DEPS)
	$(CC) -g -c -o $@ $< $(CFLAGS)
