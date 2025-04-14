
#[ctor::ctor]
fn bad_example() {
    println!("Hello, world!"); // BAD: the println! macro calls std library functions
}
