
#[ctor::ctor]
fn good_example() {
    libc_print::libc_println!("Hello, world!"); // GOOD: libc-print does not use the std library
}
