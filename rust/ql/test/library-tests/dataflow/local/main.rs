fn variable() {
    let s = "Hello";
    println!("{:?} data flow!", s);
}

fn if_expression(cond: bool) -> i64 {
    let a = 1;
    let b = 2;
    let c = if cond {
        a
    } else {
        b
    };
    c
}

fn loop_expression() -> i64 {
    let a = 1;
    let b = loop {
        break a;
    };
    b
}

fn assignment() -> i64 {
    let mut i = 1;
    i = 2;
    i
}

fn match_expression(a: i64, b: i64, c: Option<i64>) -> i64 {
    match c {
        Some(_) => a,
        None => b,
    }
}

fn main() {
    variable();
    if_expression(true);
}
