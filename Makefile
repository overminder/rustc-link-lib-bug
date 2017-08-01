# Also happens when cross compiling.
# TARGET = arm-linux-androideabi
# CC := $(TARGET)-gcc
# AR := $(TARGET)-ar

all : libfoo.a libbar.a

clean :
	rm *.a *.o main

%.a : %.o
	$(AR) cr $@ $^

%.o : %.c
	$(CC) -c $^ -o $@

main : main.c libfoo.a libbar.a
	$(CC) $< -L. -lfoo -lbar -o $@
