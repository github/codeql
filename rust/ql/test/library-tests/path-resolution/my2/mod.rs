pub mod nested2; // I8

fn g() {
    println!("my2/mod.rs::g"); // $ item=println
    nested2::nested3::nested4::f(); // $ item=I12
} // I9

pub use nested2::nested5::*; // $ item=I114

#[rustfmt::skip]
pub use nested2::nested7::nested8::{ // $ item=I118
    self, // $ item=I118
    f as nested8_f // $ item=I119
};

use nested2::nested5::nested6::f as nested6_f; // $ item=I116

use std::ops::Deref; // $ item=Deref

pub mod my3;

#[path = "renamed.rs"]
mod mymod;

pub use mymod::f; // $ item=I1001
