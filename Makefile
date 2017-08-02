# Seems to only affect Linux but not OSX.
TARGET = arm-linux-androideabi

CFLAGS := -fPIC

ifneq ($(TARGET),)
CARGO_FLAGS := --target=$(TARGET)
CC := $(TARGET)-gcc
AR := $(TARGET)-ar
endif

LIBS = native/libfoo.a native/libbar.a

all : clean $(LIBS) test

.PHONY: test
test :
	cd rust-main; \
	cargo clean; \
	cargo build $(CARGO_FLAGS)

clean :
	rm native/*.a native/*.o native/main -f

native/libfoo.a : native/libfoo.o
	$(AR) cr $@ $^

native/libbar.a : native/libbar.o
	$(AR) cr $@ $^

%.o : %.c
	$(CC) -c $^ $(CFLAGS) -o $@

native/main : native/main.c native/libfoo.a native/libbar.a
	$(CC) $< -Lnative -lbar -lfoo -o $@
