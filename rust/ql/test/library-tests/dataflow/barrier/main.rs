fn source() -> &'static str {
    "source"
}

fn sink(s: &str) {
    println!("{}", s);
}

fn sanitize(s: &str) -> &str {
    match s {
        "dangerous" => "",
        s => s
    }
}

fn no_barrier() {
    let s = source();
    sink(s);
}

fn with_barrier() {
    let s = source();
    let s = sanitize(s);
    sink(s);
}

fn main() {
    let s = source();
    sink(s);
}
