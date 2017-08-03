# Also works when cross compiling. 
# TARGET = arm-linux-androideabi

CFLAGS := -fPIC
# LD := clang-4.0 -fuse-ld=lld
LD := $(CC)

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

%.a : %.o
	$(AR) cr $@ $^

%.o : %.c
	$(CC) -c $^ $(CFLAGS) -o $@

native/main : native/main.c $(LIBS)
	$(LD) $< -Lnative -lfoo -lbar -o $@
