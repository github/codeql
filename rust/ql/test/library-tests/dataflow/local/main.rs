// Tests for intraprocedural data flow.

fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
}

// -----------------------------------------------------------------------------
// Simple data flow through expressions and assignments

fn direct() {
    sink(source(1)); // $ hasValueFlow=1
}

fn variable_usage() {
    let s = source(2);
    sink(s); // $ hasValueFlow=2
}

fn if_expression(cond: bool) {
    let a = source(3);
    let b = 2;
    let c = if cond { a } else { b };
    sink(c); // $ hasValueFlow=3
}

fn match_expression(m: Option<i64>) {
    let a = source(4);
    let b = match m {
        Some(_) => a,
        None => 0,
    };
    sink(b); // $ hasValueFlow=4
}

fn loop_with_break() {
    let a = loop {
        break 1;
    };
    sink(a);
    let b = loop {
        break source(5);
    };
    sink(b); // $ hasValueFlow=5
}

fn assignment() {
    let mut i = 1;
    sink(i);
    i = source(6);
    sink(i); // $ hasValueFlow=6
}

// -----------------------------------------------------------------------------
// Data flow through data structures by writing and reading

fn box_deref() {
    let i = Box::new(source(7));
    sink(*i); // $ MISSING: hasValueFlow=7
}

fn tuple() {
    let a = (source(8), 2);
    sink(a.0); // $ MISSING: hasValueFlow=8
    sink(a.1);
}

struct Point {
    x: i64,
    y: i64,
    z: i64,
}

fn struct_field() {
    let p = Point {
        x: source(9),
        y: 2,
        z: source(10),
    };
    sink(p.x); // $ MISSING: hasValueFlow=9
    sink(p.y);
    sink(p.z); // $ MISSING: hasValueFlow=10
}

// -----------------------------------------------------------------------------
// Data flow through data structures by pattern matching

fn struct_pattern_match() {
    let p = Point {
        x: source(11),
        y: 2,
        z: source(12),
    };
    let Point { x: a, y: b, z: c } = p;
    sink(a); // $ MISSING: hasValueFlow=11
    sink(b);
    sink(c); // $ MISSING: hasValueFlow=12
}

fn option_pattern_match_qualified() {
    let s1 = Option::Some(source(13));
    let s2 = Option::Some(2);
    match s1 {
        Option::Some(n) => sink(n), // $ MISSING: hasValueFlow=13
        Option::None => sink(0),
    }
    match s2 {
        Option::Some(n) => sink(n),
        Option::None => sink(0),
    }
}

fn option_pattern_match_unqualified() {
    let s1 = Some(source(14));
    let s2 = Some(2);
    match s1 {
        Some(n) => sink(n), // $ MISSING: hasValueFlow=14
        None => sink(0),
    }
    match s2 {
        Some(n) => sink(n),
        None => sink(0),
    }
}

enum MyTupleEnum {
    A(i64),
    B(i64),
}

fn custom_tuple_enum_pattern_match_qualified() {
    let s1 = MyTupleEnum::A(source(15));
    let s2 = MyTupleEnum::B(2);
    match s1 {
        MyTupleEnum::A(n) => sink(n), // $ MISSING: hasValueFlow=15
        MyTupleEnum::B(n) => sink(n),
    }
    match s1 {
        (MyTupleEnum::A(n) | MyTupleEnum::B(n)) => sink(n), // $ MISSING: hasValueFlow=15
    }
    match s2 {
        MyTupleEnum::A(n) => sink(n),
        MyTupleEnum::B(n) => sink(n),
    }
}

use crate::MyTupleEnum::*;

fn custom_tuple_enum_pattern_match_unqualified() {
    let s1 = A(source(16));
    let s2 = B(2);
    match s1 {
        A(n) => sink(n), // $ MISSING: hasValueFlow=16
        B(n) => sink(n),
    }
    match s1 {
        (A(n) | B(n)) => sink(n), // $ MISSING: hasValueFlow=16
    }
    match s2 {
        A(n) => sink(n),
        B(n) => sink(n),
    }
}

enum MyRecordEnum {
    C { field_c: i64 },
    D { field_d: i64 },
}

fn custom_record_enum_pattern_match_qualified() {
    let s1 = MyRecordEnum::C {
        field_c: source(17),
    };
    let s2 = MyRecordEnum::D { field_d: 2 };
    match s1 {
        MyRecordEnum::C { field_c: n } => sink(n), // $ MISSING: hasValueFlow=17
        MyRecordEnum::D { field_d: n } => sink(n),
    }
    match s1 {
        (MyRecordEnum::C { field_c: n } | MyRecordEnum::D { field_d: n }) => sink(n), // $ MISSING: hasValueFlow=17
    }
    match s2 {
        MyRecordEnum::C { field_c: n } => sink(n),
        MyRecordEnum::D { field_d: n } => sink(n),
    }
}

use crate::MyRecordEnum::*;

fn custom_record_enum_pattern_match_unqualified() {
    let s1 = C {
        field_c: source(18),
    };
    let s2 = D { field_d: 2 };
    match s1 {
        C { field_c: n } => sink(n), // $ MISSING: hasValueFlow=18
        D { field_d: n } => sink(n),
    }
    match s1 {
        (C { field_c: n } | D { field_d: n }) => sink(n), // $ MISSING: hasValueFlow=18
    }
    match s2 {
        C { field_c: n } => sink(n),
        D { field_d: n } => sink(n),
    }
}

fn block_expression1() -> i64 {
    let a = { 0 };
    a
}

fn block_expression2(b: bool) -> i64 {
    let a = 'block: {
        if b {
            break 'block 1;
        };
        2
    };
    a
}

fn block_expression3(b: bool) -> i64 {
    let a = 'block: {
        if b {
            break 'block 1;
        }
        break 'block 2;
    };
    a
}

fn main() {
    direct();
    variable_usage();
    if_expression(true);
    match_expression(Some(0));
    loop_with_break();
    assignment();
    box_deref();
    tuple();
    struct_field();
    struct_pattern_match();
    option_pattern_match_qualified();
    option_pattern_match_unqualified();
    custom_tuple_enum_pattern_match_qualified();
    custom_tuple_enum_pattern_match_unqualified();
    custom_record_enum_pattern_match_qualified();
    custom_record_enum_pattern_match_unqualified();
    block_expression1();
    block_expression2(true);
    block_expression3(true);
}
