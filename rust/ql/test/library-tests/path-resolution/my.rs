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
