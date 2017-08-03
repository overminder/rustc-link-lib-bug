#![no_std]

extern {
    #[link_name = "foo"]
    pub fn cfoo();
}

pub fn foo() {
    // This in-lib use helps to re-export `foo` in the generated rlib.
    /*
    unsafe {
        cfoo()
    }
    */
}
