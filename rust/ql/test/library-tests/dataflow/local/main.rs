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
    sink(a1); // $ hasValueFlow=38
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
    sink(b.0 .0);
    sink(b.0 .1); // $ hasValueFlow=59
    sink(b.1);
}

// -----------------------------------------------------------------------------
// Data flow through structs

struct Point {
    x: i64,
    y: i64,
}

fn struct_field() {
    let p = Point { x: source(9), y: 2 };
    sink(p.x); // $ MISSING: hasValueFlow=9
    sink(p.y);
}

fn struct_mutation() {
    let mut p = Point { x: source(9), y: 2 };
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
    z: i64,
}

fn struct_nested_field() {
    let p = Point3D {
        plane: Point {
            x: 2,
            y: source(77),
        },
        z: 4,
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
        z: 4,
    };
    match p {
        Point3D {
            plane: Point { x, y },
            z,
        } => {
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
        Option::Some(n) => sink(n), // $ hasValueFlow=13
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

fn option_unwrap_or() {
    let s1 = Some(source(46));
    sink(s1.unwrap_or(0)); // $ hasValueFlow=46

    let s2 = Some(0);
    sink(s2.unwrap_or(source(47))); // $ hasValueFlow=47
}

fn option_unwrap_or_else() {
    let s1 = Some(source(47));
    sink(s1.unwrap_or_else(|| 0)); // $ hasValueFlow=47

    let s2 = None;
    sink(s2.unwrap_or_else(|| source(48))); // $ hasValueFlow=48
}

fn option_questionmark() -> Option<i64> {
    let s1 = Some(source(20));
    let s2 = Some(2);
    let i1 = s1?;
    sink(i1); // $ hasValueFlow=20
    sink(s2?);
    Some(0)
}

fn result_questionmark() -> Result<i64, i64> {
    let s1: Result<i64, i64> = Ok(source(20));
    let s2: Result<i64, i64> = Ok(2);
    let s3: Result<i64, i64> = Err(source(77));
    let i1 = s1?;
    let i2 = s2?;
    sink(i1); // $ hasValueFlow=20
    sink(i2);
    let i3 = s3?;
    sink(i3); // No flow since value is in `Err`.
    Ok(0)
}

fn result_expect() {
    let s1: Result<i64, i64> = Ok(source(78));
    sink(s1.expect("")); // $ hasValueFlow=78
    sink(s1.expect_err(""));

    let s2: Result<i64, i64> = Err(source(79));
    sink(s2.expect(""));
    sink(s2.expect_err("")); // $ hasValueFlow=79
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
        A(n) => sink(n), // $ hasValueFlow=16
        B(n) => sink(n),
    }
    match s1 {
        A(n) | B(n) => sink(n), // $ hasValueFlow=16
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
        C { field_c: n } => sink(n), // $ hasValueFlow=18
        D { field_d: n } => sink(n),
    }
    match s1 {
        C { field_c: n } | D { field_d: n } => sink(n), // $ hasValueFlow=18
    }
    match s2 {
        C { field_c: n } => sink(n),
        D { field_d: n } => sink(n),
    }
}

// -----------------------------------------------------------------------------
// Data flow through arrays

fn array_lookup() {
    let arr1 = [1, 2, source(94)];
    let n1 = arr1[2];
    sink(n1); // $ hasValueFlow=94

    let arr2 = [source(20); 10];
    let n2 = arr2[4];
    sink(n2); // $ hasValueFlow=20

    let arr3 = [1, 2, 3];
    let n3 = arr3[2];
    sink(n3);
}

fn array_for_loop() {
    let arr1 = [1, 2, source(43)];
    for n1 in arr1 {
        sink(n1); // $ hasValueFlow=43
    }

    let arr2 = [1, 2, 3];
    for n2 in arr2 {
        sink(n2);
    }
}

fn array_slice_pattern() {
    let arr1 = [1, 2, source(43)];
    match arr1 {
        [a, b, c] => {
            sink(a); // $ SPURIOUS: hasValueFlow=43
            sink(b); // $ SPURIOUS: hasValueFlow=43
            sink(c); // $ hasValueFlow=43
        }
    }
}

fn array_assignment() {
    let mut mut_arr = [1, 2, 3];
    sink(mut_arr[1]);

    mut_arr[1] = source(55);
    let d = mut_arr[1];
    sink(d); // $ hasValueFlow=55
    sink(mut_arr[0]); // $ SPURIOUS: hasValueFlow=55
}

// Test data flow inconsistency occuring with captured variables and `continue`
// in a loop.
pub fn captured_variable_and_continue(names: Vec<(bool, Option<String>)>) {
    let default_name = source(83).to_string();
    for (cond, name) in names {
        if cond {
            let n = name.unwrap_or_else(|| default_name.to_string());
            sink(n.len() as i64);
            continue;
        }
    }
}

macro_rules! get_source {
    ($e:expr) => {
        source($e)
    };
}

fn macro_invocation() {
    let s = get_source!(37);
    sink(s); // $ hasValueFlow=37
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
    option_unwrap_or();
    option_questionmark();
    let _ = result_questionmark();
    custom_tuple_enum_pattern_match_qualified();
    custom_tuple_enum_pattern_match_unqualified();
    custom_record_enum_pattern_match_qualified();
    custom_record_enum_pattern_match_unqualified();
    block_expression1();
    block_expression2(true);
    block_expression3(true);
    array_lookup();
    array_for_loop();
    array_slice_pattern();
    array_assignment();
    captured_variable_and_continue(vec![]);
    macro_invocation();
}
