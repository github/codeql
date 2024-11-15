fn main() {
    let who = "world";
    println!("Hello {who}!")
}

fn empty_block() {}

fn single_empty_block() {
    {}
}

macro_rules! block {
    (Empty) => {};
    (Stmt) => {
        main();
    };
    (Nested) => {
        block!(Stmt)
    };
}

fn macro_stmts() {
    block!(Empty);
    block!(Stmt);
    block!(Nested);
}
fn format_template_variables() {
    let width = 4;
    let precision = 2;
    let value = 10;
    println!("Value {value:#width$.precision$}");
}

fn chained_if(x: i32) {
    if x < 5 {
        println!("small");
    } else if x > 10 {
        println!("large");
    } else {
        println!("medium");
    }
}

fn literal_in_pat(pair: (bool, bool)) -> bool {
    match pair {
        (x, true) => x,
        _ => false,
    }
}

fn box_new() {
    vec![1];
}
