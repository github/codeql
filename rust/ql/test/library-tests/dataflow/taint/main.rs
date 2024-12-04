// Tests for taint flow.

fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
}

fn addition() {
    let a = source(42);
    sink(a + 1); // $ MISSING: hasTaintFlow=42
}

fn negation() {
    let a = source(17);
    sink(-a); // $ MISSING: hasTaintFlow=17
}

fn cast() {
    let a = source(77);
    let b = a as u8;
    sink(b as i64); // $ MISSING: hasTaintFlow=77
}

fn main() {
    addition();
    negation();
    cast();
}
