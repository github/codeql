#[proc_macro::add_one]
pub fn foo() {}

pub fn bar() {
    foo_new();
}