extern {
    pub fn foo();
}

#[test]
fn test() {
    unsafe {
        foo();
    }
}
