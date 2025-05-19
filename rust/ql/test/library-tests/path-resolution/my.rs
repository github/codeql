pub mod nested; // I37

use nested::g; // $ item=I7

pub fn f() {
    println!("my.rs::f");
} // I38

pub fn h() {
    println!("my.rs::h");
    g(); // $ item=I7
} // I39

mod my4 {
    pub mod my5;
}

pub use my4::my5::f as nested_f; // $ item=I201
#[rustfmt::skip]
type Result<
    T, // T
> = ::std::result::Result<
    T, // $ item=T
    String,> // $ item=Result
; // my::Result

fn int_div(
    x: i32, // $ item=i32
    y: i32, // $ item=i32
) -> Result<i32> // $ item=my::Result $ item=i32
{
    if y == 0 {
        return Err("Div by zero".to_string()); // $ item=Err
    }
    Ok(x / y) // $ item=Ok
}
