pub fn f() {
    println!("my2/my3/mod.rs::f");
    g(); // $ MISSING: item=I9
    h(); // $ MISSING: item=I25
} // I200

use super::super::h; // $ MISSING: item=I25
use super::g; // $ MISSING: item=I9
