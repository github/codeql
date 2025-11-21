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

fn sink_ref(sr: &str) {
    println!("{}", sr);
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

    sink(s4); // $ SPURIOUS: hasValueFlow=83 MISSING: hasTaintFlow=83
    sink(s5);
}

fn string_add_reference() {
    let s1 = source(37);
    let s2 = "1".to_string();

    sink("Hello ".to_string() + &s1); // $ hasTaintFlow=37
    sink("Hello ".to_string() + &s2);
}

fn string_conversions() {
    let s1 = source_slice(36);

    let s2 = String::from(s1);
    sink(s2); // $ hasTaintFlow=36
    let s3 = String::try_from(s1).unwrap();
    sink(s3); // $ MISSING: hasTaintFlow=36
    let s4: String = s1.into();
    sink(s4); // $ MISSING: hasTaintFlow=36
    let s5: String = s1.try_into().unwrap();
    sink(s5); // $ MISSING: hasTaintFlow=36

    let ss: [&str; 2] = [source_slice(37), source_slice(38)];
    sink_slice(ss[0]); // $ hasValueFlow=37 SPURIOUS: hasValueFlow=38

    let s5 = String::from(ss[0]);
    sink(s5); // $ hasTaintFlow=37 SPURIOUS: hasTaintFlow=38
    let s6 = String::try_from(ss[0]).unwrap();
    sink(s6); // $ MISSING: hasTaintFlow=37
    let s7: String = ss[0].into();
    sink(s7); // $ MISSING: hasTaintFlow=37
    let s8: String = ss[0].try_into().unwrap();
    sink(s8); // $ MISSING: hasTaintFlow=37

    let ss2: Vec<&str> = Vec::from(ss);
    sink_slice(ss2[0]); // $ hasTaintFlow=37 SPURIOUS: hasTaintFlow=38
    let ss3: Vec<&str> = Vec::try_from(ss).unwrap();
    sink_slice(ss3[0]); // $ MISSING: hasTaintFlow=37
    let ss4: Vec<&str> = ss.into();
    sink_slice(ss4[0]); // $ MISSING: hasTaintFlow=37
    let ss5: Vec<&str> = ss.try_into().unwrap();
    sink_slice(ss5[0]); // $ MISSING: hasTaintFlow=37
}

fn string_to_string() {
    let s1 = source_slice(22);
    let s2 = s1.to_string();
    sink(s2); // $ hasTaintFlow=22
}

fn as_str() {
    let s = source(67);
    sink_slice(s.as_str()); // $ hasValueFlow=67
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

fn refs() {
    let mut s1 = source(90).to_string();

    sink_ref(&s1); // $ hasTaintFlow=90
    sink_ref(s1.as_ref()); // $ hasTaintFlow=90
    sink_ref(s1.as_mut()); // $ hasTaintFlow=90
}

fn main() {
    string_slice();
    string_add();
    string_add_reference();
    string_conversions();
    as_str();
    string_to_string();
    format_args_built_in();
    format_macro();
    refs();
}
