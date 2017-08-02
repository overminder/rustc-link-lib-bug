extern crate foo_sys;

extern {
    #[link_name = "bar"]
    fn cbar();
}

pub fn bar() {
    foo_sys::foo();
    unsafe { cbar() }
}

#[test]
fn test() {
    bar();
}
