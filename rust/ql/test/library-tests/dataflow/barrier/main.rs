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
    sink(s);
}

fn main() {
    let s = source(1);
    sink(s); // $ hasValueFlow=1
}

fn verify_safe(s: &str) -> bool {
    match s {
        "dangerous" => false,
        _ => true,
    }
}

fn with_barrier_guard() {
    let s = source(1);
    if verify_safe(s) {
        sink(s);
    }
}
