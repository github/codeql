use proc_macros::repeat;

#[repeat(3)]
fn foo() {
    _ = concat!("Hello ", "world!");

    #[repeat(2)]
    fn inner() {}
}

#[repeat(2)]
#[repeat(3)]
fn bar() {}

#[repeat(0)]
fn baz() {}
