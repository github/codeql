pub fn f() {
    println!("my2/my3/mod.rs::f");
    g(); // $ item=I9
    h(); // $ item=I25
} // I200

use super::super::h; // $ item=I25
use super::g; // $ item=I9
