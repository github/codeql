pub mod nested2; // I8

fn g() {
    println!("my2/mod.rs::g");
    nested2::nested3::nested4::f(); // $ item=I12
} // I9

pub use nested2::nested5::*; // $ item=I114

pub use nested2::nested7::nested8::{self}; // $ item=I118

pub mod my3;

#[path = "renamed.rs"]
mod mymod;

use mymod::f; // $ item=I1001
