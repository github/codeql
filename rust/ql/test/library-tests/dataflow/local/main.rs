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

fn main() {
    variable();
    if_expression(true);
}
