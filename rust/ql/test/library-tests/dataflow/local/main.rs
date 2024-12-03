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

// -----------------------------------------------------------------------------
// Data flow through `Box`

fn box_deref() {
    let i = Box::new(source(7));
    sink(*i); // $ MISSING: hasValueFlow=7
}

// -----------------------------------------------------------------------------
// Data flow through tuples

fn tuple() {
    let a = (source(8), 2);
    sink(a.0); // $ hasValueFlow=8
    sink(a.1);
}

fn tuple_match() {
    let a = (2, source(38), 2);
    let (a0, a1, a2) = a;
    sink(a0);
    sink(a1); // $ MISSING: hasValueFlow=38
    sink(a2);
}

fn tuple_mutation() {
    let mut a = (2, source(38));
    sink(a.0);
    sink(a.1); // $ hasValueFlow=38
    a.0 = source(70);
    a.1 = 2;
    sink(a.0); // $ hasValueFlow=70
    sink(a.1);
}

fn tuple_nested() {
    let a = (3, source(59));
    let b = (a, 3);
    sink(b.0.0);
    sink(b.0.1); // $ hasValueFlow=59
    sink(b.1);
}

// -----------------------------------------------------------------------------
// Data flow through structs

struct Point {
    x: i64,
    y: i64,
}

fn struct_field() {
    let p = Point {
        x: source(9),
        y: 2,
    };
    sink(p.x); // $ MISSING: hasValueFlow=9
    sink(p.y);
}

fn struct_mutation() {
    let mut p = Point {
        x: source(9),
        y: 2,
    };
    sink(p.y);
    p.y = source(54);
    sink(p.y); // $ MISSING: hasValueFlow=54
}

fn struct_pattern_match() {
    let p = Point {
        x: source(11),
        y: 2,
    };
    let Point { x: a, y: b } = p;
    sink(a); // $ hasValueFlow=11
    sink(b);
}

struct Point3D {
    plane: Point,
    z: i64
}

fn struct_nested_field() {
    let p = Point3D {
        plane: Point {
            x: 2,
            y: source(77),
        },
        z: 4
    };
    sink(p.plane.x);
    sink(p.plane.y); // $ MISSING: hasValueFlow=77
    sink(p.z);
}

fn struct_nested_match() {
    let p = Point3D {
        plane: Point {
            x: 2,
            y: source(93),
        },
        z: 4
    };
    match p {
        Point3D { plane: Point { x, y }, z, } => {
            sink(x);
            sink(y); // MISSING: hasValueFlow=93
            sink(z);
        }
    }
}

// -----------------------------------------------------------------------------
// Data flow through enums

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
        Some(n) => sink(n), // $ hasValueFlow=14
        None => sink(0),
    }
    match s2 {
        Some(n) => sink(n),
        None => sink(0),
    }
}

fn option_unwrap() {
    let s1 = Some(source(19));
    sink(s1.unwrap()); // $ hasValueFlow=19
}

enum MyTupleEnum {
    A(i64),
    B(i64),
}

fn custom_tuple_enum_pattern_match_qualified() {
    let s1 = MyTupleEnum::A(source(15));
    let s2 = MyTupleEnum::B(2);
    match s1 {
        MyTupleEnum::A(n) => sink(n), // $ hasValueFlow=15
        MyTupleEnum::B(n) => sink(n),
    }
    match s1 {
        MyTupleEnum::A(n) | MyTupleEnum::B(n) => sink(n), // $ hasValueFlow=15
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
        A(n) | B(n) => sink(n), // $ MISSING: hasValueFlow=16
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
        MyRecordEnum::C { field_c: n } => sink(n), // $ hasValueFlow=17
        MyRecordEnum::D { field_d: n } => sink(n),
    }
    match s1 {
        MyRecordEnum::C { field_c: n } | MyRecordEnum::D { field_d: n } => sink(n), // $ hasValueFlow=17
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
        C { field_c: n } | D { field_d: n } => sink(n), // $ MISSING: hasValueFlow=18
    }
    match s2 {
        C { field_c: n } => sink(n),
        D { field_d: n } => sink(n),
    }
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
    tuple_match();
    tuple_mutation();
    tuple_nested();
    struct_field();
    struct_mutation();
    struct_pattern_match();
    struct_nested_field();
    struct_nested_match();
    option_pattern_match_qualified();
    option_pattern_match_unqualified();
    option_unwrap();
    custom_tuple_enum_pattern_match_qualified();
    custom_tuple_enum_pattern_match_unqualified();
    custom_record_enum_pattern_match_qualified();
    custom_record_enum_pattern_match_unqualified();
    block_expression1();
    block_expression2(true);
    block_expression3(true);
}
