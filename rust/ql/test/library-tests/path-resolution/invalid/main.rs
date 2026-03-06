// The code in this file is not valid Rust code

struct A; // A1
struct A; // A2

fn f(x: A) {} // $ item=A2 (the latter occurence takes precedence)
