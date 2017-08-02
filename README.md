### What's This

Recently I encountered a strange linkage error when building FFI library bindings
with rust and cargo. I'm not sure if it's a bug but it's surely annoying.
Here is a minimal working example of the problem. 

### Example Description

Let's say you have two static libraries: `libfoo.a` and `libbar.a`, where
the later depends on a symbol from the former.

You are writing two FFI binding crates, `rust-foo-sys` and `rust-bar-sys` for these
libraries. To do this, you print `cargo:rustc-link-lib={kind}={libname}` in
both crates' build scripts. In in the former crate you specify `kind`
to be `static` but in the later crate you don't specify
the `kind` and leave the choice to the compiler.

The said error occurs when you are building an executable that depends on
`rust-bar-sys`.

### OS / Toolchain Versions

This problem seems to only present when targeting ELF (using gcc or clang as
the linker frontend, bfd or gold as the linker). Both x86_64 and arm targets are affected.

See the [detailed toolchain versions here](toolchain-versions.md).

### Running the Example

Make sure you have cargo, gcc and ar installed:

then run

    make

at the repo root to build both the native static libraries and the
rust-main crate.

cargo should fail with something like this:

    note: ../native/libbar.a(libbar.o): In function `bar':
    libbar.c:(.text+0xa): undefined reference to `foo'
    collect2: error: ld returned 1 exit status

### Further Observation

There are several individual tweaks that I found to be able to fix this problem but I couldn't understand why:

- Set `rust-bar-sys`'s `cargo:rustc-link-lib` `kind` to be `static`.
- Remove the `kind` option in `rust-foo-sys`'s `cargo:rustc-link-lib` flag.
- Swap the `cargo:rustc-link-lib` flags in `rust-bar-sys` so that `libbar` comes before `libfoo`. ([e.g., swap the 3rd and the 4th line here](https://github.com/overminder/rustc-link-lib-bug/blob/3b8918554e047d700a7fec185c6c0bf9e9896e03/rust-bar-sys/build.rs))
  * This does look like a typical static library link order issue...
