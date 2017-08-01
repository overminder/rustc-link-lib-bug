extern crate foo;

extern {
    pub fn bar();
}

#[test]
fn test() {
    unsafe {
        bar();
    }
}
