use macros::repeat;

#[repeat(3)]
fn foo() {
    println!("Hello, world!");

    #[repeat(2)]
    fn inner() {}
}

#[repeat(2)]
#[repeat(3)]
fn bar() {}

#[repeat(0)]
fn baz() {}
