fn source(i: i64) -> &'static str {
    "source"
}

fn sink(s: &str) {
    println!("{}", s);
}

fn sanitize(s: &str) -> &str {
    match s {
        "dangerous" => "",
        s => s,
    }
}

fn directly() {
    sink(source(1)); // $ hasValueFlow=1
}

fn through_variable() {
    let s = source(1);
    sink(s); // $ hasValueFlow=1
}

fn with_barrier() {
    let s = source(1);
    let s = sanitize(s);
    sink(s); // $ SPURIOUS: hasValueFlow=1
}

fn main() {
    let s = source(1);
    sink(s); // $ hasValueFlow=1
}
