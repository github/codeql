use macros::repeat;

#[repeat(3)]
fn foo() {}

#[repeat(2)]
#[repeat(3)]
fn bar() {}

#[repeat(0)]
fn baz() {}
