fn main() {
    println!("cargo:rustc-link-search=native=../native");
    println!("cargo:rustc-link-lib=foo");
    println!("cargo:rustc-link-lib=bar");
    println!("cargo:rustc-link-lib=foo");
}
