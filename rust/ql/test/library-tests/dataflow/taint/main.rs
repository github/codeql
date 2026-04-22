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
    sink(1 + a); // $ hasTaintFlow=42

    let mut b = source(58);
    b += 2;
    sink(b); // $ hasTaintFlow=58

    let mut c = 0;
    c += source(99);
    sink(c); // $ hasTaintFlow=99
}

fn more_ops() {
    let a = source(1);
    sink(-a); // $ hasTaintFlow=1

    sink(!source(2)); // $ hasTaintFlow=2

    sink(source(3) - 3); // $ hasTaintFlow=3
    sink(4i64 - source(4)); // $ hasTaintFlow=4

    sink(source(5) * 5); // $ hasTaintFlow=5
    sink(6i64 * source(6)); // $ hasTaintFlow=6

    sink(source(7) << 7); // $ hasTaintFlow=7
    sink(8i64 << source(8)); // $ hasTaintFlow=8

    sink(source(9) ^ 9); // $ hasTaintFlow=9
    sink(10i64 ^ source(10)); // $ hasTaintFlow=10
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

mod tuples {
    fn source_string(i: i64) -> String {
        "".to_string()
    }

    fn source_tuple(i: i64) -> (String, String) {
        ("".to_string(), "".to_string())
    }

    fn sink<T>(t: T) {
    }

    pub fn tuples() {
        sink((source_string(1), "".to_string()));
        sink((source_string(1), "".to_string()).0); // $ hasValueFlow=1
        sink((source_string(1), "".to_string()).1);

        sink(source_tuple(2)); // $ hasValueFlow=2
        sink(source_tuple(2).0); // $ hasTaintFlow=2
        sink(source_tuple(2).1); // $ hasTaintFlow=2

        sink((("".to_string(), source_string(3)), ("".to_string(), "".to_string())));
        sink((("".to_string(), source_string(3)), ("".to_string(), "".to_string())).0);
        sink((("".to_string(), source_string(3)), ("".to_string(), "".to_string())).0.0);
        sink((("".to_string(), source_string(3)), ("".to_string(), "".to_string())).0.1); // $ hasValueFlow=3
        sink((("".to_string(), source_string(3)), ("".to_string(), "".to_string())).1);
        sink((("".to_string(), source_string(3)), ("".to_string(), "".to_string())).1.0);
        sink((("".to_string(), source_string(3)), ("".to_string(), "".to_string())).1.1);

        sink((source_tuple(4), ("".to_string(), "".to_string())));
        sink((source_tuple(4), ("".to_string(), "".to_string())).0); // $ hasValueFlow=4
        sink((source_tuple(4), ("".to_string(), "".to_string())).0.0); // $ hasTaintFlow=4
        sink((source_tuple(4), ("".to_string(), "".to_string())).0.1); // $ hasTaintFlow=4
        sink((source_tuple(4), ("".to_string(), "".to_string())).1);
        sink((source_tuple(4), ("".to_string(), "".to_string())).1.0);
        sink((source_tuple(4), ("".to_string(), "".to_string())).1.1);
    }
}

use std::ops::{Add, Sub, Mul, Shl, Shr, BitOr, AddAssign, SubAssign, MulAssign, ShlAssign, ShrAssign, BitXorAssign, Neg, Not};

fn std_ops() {
    sink(source(1).add(2i64)); // $ hasTaintFlow=1
    sink(source(1).add(2)); // $ MISSING: hasTaintFlow=1 --- the missing results here are due to failing to resolve targets for `add` etc where there's no explicit type
    sink(1i64.add(source(2))); // $ hasTaintFlow=2
    sink(1.add(source(2))); // $ MISSING: hasTaintFlow=2

    sink(source(1).sub(2i64)); // $ hasTaintFlow=1
    sink(source(1).sub(2)); // $ MISSING: hasTaintFlow=1
    sink(1i64.sub(source(2))); // $ hasTaintFlow=2
    sink(1.sub(source(2))); // $ MISSING: hasTaintFlow=2

    sink(source(1).mul(2i64)); // $ hasTaintFlow=1
    sink(source(1).mul(2)); // $ MISSING: hasTaintFlow=1
    sink(1i64.mul(source(2))); // $ hasTaintFlow=2
    sink(1.mul(source(2))); // $ MISSING: hasTaintFlow=2

    sink(source(1).shl(2i64)); // $ hasTaintFlow=1
    sink(source(1).shl(2)); // $ hasTaintFlow=1
    sink(1i64.shl(source(2))); // $ hasTaintFlow=2

    sink(source(1).shr(2i64)); // $ hasTaintFlow=1
    sink(source(1).shr(2)); // $ hasTaintFlow=1
    sink(1i64.shr(source(2))); // $ hasTaintFlow=2

    sink(source(1).bitor(2i64)); // $ hasTaintFlow=1
    sink(source(1).bitor(2)); // $ MISSING: hasTaintFlow=1
    sink(1i64.bitor(source(2))); // $ hasTaintFlow=2
    sink(1.bitor(source(2))); // $ MISSING: hasTaintFlow=2

    let mut a: i64 = 1;
    a.add_assign(source(2));
    a.sub_assign(source(3));
    a.mul_assign(source(4));
    a.shl_assign(source(5));
    a.shr_assign(source(6));
    a.bitxor_assign(source(7));
    sink(a); // $ hasTaintFlow=2 hasTaintFlow=3 hasTaintFlow=4 hasTaintFlow=5 hasTaintFlow=6 hasTaintFlow=7

    sink(source(1).neg()); // $ hasTaintFlow=1
    sink(source(1).not()); // $ hasTaintFlow=1
}

mod wrapping {
    use std::num::Wrapping;
    use std::ops::{Add, AddAssign, Neg, Not};

    fn source(i: i64) -> Wrapping<i64> {
        Wrapping(i)
    }

    fn source_usize(i: i64) -> usize {
        i as usize
    }

    fn sink(s: Wrapping<i64>) {
        println!("{}", s);
    }

    pub fn wrapping() {
        let mut a: Wrapping<i64> = Wrapping(crate::source(1));
        sink(a); // $ MISSING: hasTaintFlow=1
        crate::sink(a.0); // $ hasValueFlow=1

        a.add_assign(source(2));
        a.add_assign(Wrapping(crate::source(3)));
        sink(a); // $ hasTaintFlow=2 MISSING: hasTaintFlow=1 hasTaintFlow=3
        crate::sink(a.0); // $ hasValueFlow=1 hasTaintFlow=2 hasTaintFlow=3

        a = source(4);
        a += source(5);
        a += std::num::Wrapping(crate::source(6));
        sink(a); // $ hasTaintFlow=4 hasTaintFlow=5 MISSING: hasTaintFlow=6
        crate::sink(a.0); // $ hasTaintFlow=4 hasTaintFlow=5 hasTaintFlow=6

        a = source(7);
        a &= source(8);
        a &= Wrapping(crate::source(9));
        sink(a); // $ hasTaintFlow=7 hasTaintFlow=8 MISSING: hasTaintFlow=9
        crate::sink(a.0); // $ hasTaintFlow=7 hasTaintFlow=8 hasTaintFlow=9

        a = source(10);
        a <<= source_usize(11);
        sink(a); // $ hasTaintFlow=11 hasTaintFlow=10
        crate::sink(a.0); // $ hasTaintFlow=11 hasTaintFlow=10

        let b: Wrapping<i64> = Wrapping(crate::source(1));
        let c: Wrapping<i64> = Wrapping(crate::source(2));
        let v1 = b + c;
        crate::sink(v1.0); // $ hasTaintFlow=1 hasTaintFlow=2
        let v2 = b.add(c);
        crate::sink(v2.0); // $ hasTaintFlow=1 hasTaintFlow=2
        let v3 = -b;
        crate::sink(v3.0); // $ hasTaintFlow=1
        let v4 = b.neg();
        crate::sink(v4.0); // $ hasTaintFlow=1
        let v5 = !b;
        crate::sink(v5.0); // $ hasTaintFlow=1
        let v6 = b.not();
        crate::sink(v6.0); // $ hasTaintFlow=1
        let v7 = b & c;
        crate::sink(v7.0); // $ hasTaintFlow=1 hasTaintFlow=2
        let v8 = b << source_usize(3);
        crate::sink(v8.0); // $ hasTaintFlow=1 hasTaintFlow=3
    }
}

fn main() {
    addition();
    more_ops();
    cast();
    string_slice();
    array_source::array_tainted();
    array_sink::array_with_taint();
    tuples::tuples();
    std_ops();
    wrapping::wrapping();
}
