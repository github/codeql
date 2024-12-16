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
        sink(sliced); // $ hasTaintFlow=35
    }
}

mod array_source {
    fn source(i: i64) -> [i64; 3] {
        [i; 3]
    }

    fn sink(i: i64) {
        println!("{}", i);
    }

    pub fn array_tainted() {
        let arr = source(76);
        sink(arr[1]); // $ hasTaintFlow=76
    }
}

mod array_sink {
    fn source(i: i64) -> i64 {
        i
    }

    fn sink(s: [i64; 3]) {
        println!("{}", s[1]);
    }

    pub fn array_with_taint() {
        let mut arr2 = [1, 2, 3];
        arr2[1] = source(36);
        sink(arr2); // $ hasTaintFlow=36
    }
}

use string::*;

fn main() {
    addition();
    negation();
    cast();
    string_slice();
    array_source::array_tainted();
    array_sink::array_with_taint();
}
