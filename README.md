### What's This

Recently I encountered a strange linking error when building FFI library bindings
with rust and cargo. I'm not sure if it's a bug but it's surely annoying.
Here is a minimal working example of the problem. 

### Example Description

Let's say you have two static libraries: `libfoo.a` and `libbar.a`, where
the later depends a symbol from the former.

You are writing two rust binding crates, `rust-foo-sys` and `rust-bar-sys` for these
libraries. To do this, you print `cargo:rustc-link-lib={kind}={libname}` in
both crates' build scripts. In in the former crate you specify `kind`
to be `static` but in the later crate you don't specify
the `kind` and leave the choice to the compiler.

The said error occurs when you are building an executable that depends on
`rust-bar-sys`.

### OS / Toolchain Versions

This problem seems to only present when using Linux toolchains (gcc) but not
OSX. Both x86_64 and arm targets are affected.

### Running the Example

Make sure you have cargo, gcc and ar installed:

then run

    make

at the repo root to build both the native static libraries and the
rust-main crate.

cargo should fail with something like this:

    note: ..//libbar.a(libbar.o):libbar.c:function bar: error: undefined reference to 'foo'
    collect2: error: ld returned 1 exit status

