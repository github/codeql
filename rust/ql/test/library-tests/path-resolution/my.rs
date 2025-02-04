pub mod nested; // I37

use nested::g; // $ item=I7

pub fn f() {
    println!("my.rs::f");
} // I38

pub fn h() {
    println!("my.rs::h");
    g(); // $ item=I7
} // I39
