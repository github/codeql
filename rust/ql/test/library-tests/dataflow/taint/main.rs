// Tests for taint flow.

fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
}

fn addition() {
    let a = source(42);
    sink(a + 1); // $ hasTaintFlow=42
}

fn negation() {
    let a = source(17);
    sink(-a); // $ hasTaintFlow=17
}

fn cast() {
    let a = source(77);
    let b = a as u8;
    sink(b as i64); // $ hasTaintFlow=77
}

mod string {
    fn source(i: i64) -> String {
        format!("{}", i)
    }

    fn sink(s: &str) {
        println!("{}", s);
    }

    pub fn string_slice() {
        let s = source(35);
        let sliced = &s[1..3];
        sink(sliced); // $ MISSING: hasTaintFlow=35
    }
}

use string::*;

fn main() {
    addition();
    negation();
    cast();
    string_slice();
}
