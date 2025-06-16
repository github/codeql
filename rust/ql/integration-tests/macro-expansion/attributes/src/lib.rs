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

struct S;

impl S {
    #[repeat(2)]
    pub fn bzz() {}
}

fn use_all() {
    foo_0();
    foo_1();
    foo_2();
    bar_0_0();
    bar_0_1();
    bar_0_2();
    bar_1_0();
    bar_1_1();
    bar_1_2();
    S::bzz_0();
    S::bzz_1();
}
