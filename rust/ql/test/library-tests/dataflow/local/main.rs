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
    let s = source(1);
    sink(s); // $ hasValueFlow=1
}

fn if_expression(cond: bool) {
    let a = source(1);
    let b = 2;
    let c = if cond { a } else { b };
    sink(c); // $ hasValueFlow=1
}

fn match_expression(m: Option<i64>) {
    let a = source(1);
    let b = match m {
        Some(_) => a,
        None => 0,
    };
    sink(b); // $ hasValueFlow=1
}

fn loop_with_break() {
    let a = loop {
        break 1;
    };
    sink(a);
    let b = loop {
        break source(1);
    };
    sink(b); // $ hasValueFlow=1
}

fn assignment() {
    let mut i = 1;
    sink(i);
    i = source(2);
    sink(i); // $ hasValueFlow=2
}

// -----------------------------------------------------------------------------
// Data flow through data structures by writing and reading

fn box_deref() {
    let i = Box::new(source(1));
    sink(*i); // $ MISSING: hasValueFlow=1
}

fn tuple() {
    let a = (source(1), 2);
    sink(a.0); // $ MISSING: hasValueFlow=1
    sink(a.1);
}

struct Point {
    x: i64,
    y: i64,
    z: i64,
}

fn struct_field() {
    let p = Point {
        x: source(1),
        y: 2,
        z: source(3),
    };
    sink(p.x); // MISSING: hasValueFlow=1
    sink(p.y);
    sink(p.z); // MISSING: hasValueFlow=3
}

// -----------------------------------------------------------------------------
// Data flow through data structures by pattern matching

fn struct_pattern_match() {
    let p = Point {
        x: source(1),
        y: 2,
        z: source(3),
    };
    let Point { x: a, y: b, z: c } = p;
    sink(a); // MISSING: hasValueFlow=1
    sink(b);
    sink(c); // MISSING: hasValueFlow=3
}

fn option_pattern_match() {
    let s1 = Some(source(1));
    let s2 = Some(2);
    match s1 {
        Some(n) => sink(n), // MISSING: hasValueFlow=3
        None => sink(0),
    }
    match s2 {
        Some(n) => sink(n),
        None => sink(0),
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
    option_pattern_match();
    block_expression1();
    block_expression2(true);
    block_expression3(true);
}
