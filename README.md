### What's This

Recently I encountered a strange linking error when building FFI library bindings
with rust and cargo. I'm not sure if it's a bug but it's surely annoying.
Here is a minimal working example of the problem. 

### Example Description

Let's say you have two static libraries: `libfoo.a` and `libbar.a`, where
the later depends on the former.

You are writing two rust binding crates, `rust-foo` and `rust-bar` for these
libraries. To do this, you print `cargo:rustc-link-lib={kind}={libname}` in
both crates' build scripts. In in the former crate you specify `kind`
to be `static` but in the later crate you don't specify
the `kind` and leave the choice to the compiler.

The said error occurs when you are building an executable that depends on
`rust-bar`.

### Running the Example

Make sure you have cargo, gcc / clang and ar installed:

then run

    make

at the repo root to build the native static libraries. Then cd into
rust-bar and run

    cargo test

cargo should fail with something like this (when using gcc)

    note: ..//libbar.a(libbar.o):libbar.c:function bar: error: undefined reference to 'foo'
    collect2: error: ld returned 1 exit status

or this (when using clang)

    note: Undefined symbols for architecture x86_64:
      "_foo", referenced from:
        _bar in libbar.a(libbar.o)
    ld: symbol(s) not found for architecture x86_64
    clang: error: linker command failed with exit code 1 (use -v to see invocation)

### OS / Toolchain Versions

    $ uname -a
    Darwin MAC-0124.local 16.4.0 Darwin Kernel Version 16.4.0: Thu Dec 22 22:53:21
    PST 2016; root:xnu-3789.41.3~3/RELEASE_X86_64 x86_64 i386 MacBookAir6,2 Darwin

    $ rustc --version
    rustc 1.19.0 (0ade33941 2017-07-17)

    $ cargo --version
    cargo 0.20.0 (a60d185c8 2017-07-13)

    $ gcc --version
    Configured with: --prefix=/Applications/Xcode.app/Contents/Developer/usr
    --with-gxx-include-dir=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/usr/include/c++/4.2.1
    Apple LLVM version 8.0.0 (clang-800.0.42.1)
    Target: x86_64-apple-darwin16.4.0
    Thread model: posix
    InstalledDir:
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

    $ arm-linux-androideabi-gcc --version
    arm-linux-androideabi-gcc (GCC) 4.9.x 20150123 (prerelease)
    Copyright (C) 2014 Free Software Foundation, Inc.
    This is free software; see the source for copying conditions.  There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
