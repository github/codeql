pub fn f() {
    println!("my2/my3/mod.rs::f"); // $ item=println
    g(); // $ item=I9
    h(); // $ item=I25
} // I200

use super::super::h; // $ item=I25
use super::g; // $ item=I9

use super::nested6_f; // $ item=I116

use super::*; // $ item=mod.rs

trait MyTrait: Deref {} // $ item=Deref
