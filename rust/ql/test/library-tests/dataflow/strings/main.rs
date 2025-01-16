use std::fmt;

// Taint tests for strings

fn source(i: i64) -> String {
    format!("{}", i)
}

fn source_usize(i: usize) -> usize {
    i
}

fn source_slice(_i: i64) -> &'static str {
    "source"
}

fn sink_slice(s: &str) {
    println!("{}", s);
}

fn sink(s: String) {
    println!("{}", s);
}

fn string_slice() {
    let s = source(35);
    let sliced = &s[1..2];
    sink_slice(sliced); // $ hasTaintFlow=35
}

fn string_add() {
    let s1 = source(83);
    let s2 = "2".to_owned();
    let s3 = "3";
    let s4 = s1 + s3;
    let s5 = s2 + s3;

    sink(s4); // $ hasTaintFlow=83
    sink(s5);
}

fn string_add_reference() {
    let s1 = source(37);
    let s2 = "1".to_string();

    sink("Hello ".to_string() + &s1); // $ MISSING: hasTaintFlow=37
    sink("Hello ".to_string() + &s2);
}

fn string_from() {
    let s1 = source_slice(36);
    let s2 = String::from(s1);
    sink(s2); // $ MISSING: hasTaintFlow=36
}

fn string_to_string() {
    let s1 = source_slice(22);
    let s2 = s1.to_string();
    sink(s2); // $ MISSING: hasTaintFlow=22
}

fn as_str() {
    let s = source(67);
    sink_slice(s.as_str()); // $ hasTaintFlow=67
}

fn format_args_built_in() {
    let s = source(88);

    let formatted1 = fmt::format(format_args!("Hello {}!", s));
    sink(formatted1); // $ hasTaintFlow=88

    let formatted2 = fmt::format(format_args!("Hello {s}!"));
    sink(formatted2); // $ hasTaintFlow=88

    let width = source_usize(10);
    let formatted3 = fmt::format(format_args!("Hello {:width$}!", "World"));
    sink(formatted3); // $ hasTaintFlow=10
}

fn format_macro() {
    let s1 = source(34);
    let s2 = "2";
    let s3 = "3";

    sink(format!("{}", s1)); // $ hasTaintFlow=34
    sink(format!("{s1} and {s3}")); // $ hasTaintFlow=34
    sink(format!("{s2} and {s3}"));
}

fn main() {
    string_slice();
    string_add();
    string_add_reference();
    string_from();
    as_str();
    string_to_string();
    format_args_built_in();
    format_macro();
}
