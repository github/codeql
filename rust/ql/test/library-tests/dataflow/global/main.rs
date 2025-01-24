fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
}

// -----------------------------------------------------------------------------
// Data flow in, out, and through functions.

fn get_data(n: i64) -> i64 {
    source(n)
}

fn data_out_of_call() {
    let a = get_data(7);
    sink(a); // $ hasValueFlow=n
}

fn data_in(n: i64) {
    sink(n); // $ hasValueFlow=3
}

fn data_in_to_call() {
    let a = source(3);
    data_in(a);
}

fn pass_through(i: i64) -> i64 {
    i
}

fn data_through_call() {
    let a = source(1);
    let b = pass_through(a);
    sink(b); // $ hasValueFlow=1
}

fn block_expression_as_argument() {
    let a = pass_through({
        println!("Hello");
        source(14)
    });
    sink(a); // $ hasValueFlow=14
}

fn data_through_nested_function() {
    let a = source(15);

    fn pass_through(i: i64) -> i64 {
        i
    }

    let b = pass_through(a);
    sink(b); // $ hasValueFlow=15
}

// -----------------------------------------------------------------------------
// Data flow in, out, and through method.

struct MyFlag {
    flag: bool,
}

impl MyFlag {
    fn data_in(&self, n: i64) {
        sink(n); // $ hasValueFlow=1
    }
    fn get_data(&self) -> i64 {
        if self.flag {
            0
        } else {
            source(2)
        }
    }
    fn data_through(&self, n: i64) -> i64 {
        if self.flag {
            0
        } else {
            n
        }
    }
}

fn data_out_of_method() {
    let mn = MyFlag { flag: true };
    let a = mn.get_data();
    sink(a); // $ hasValueFlow=2
}

fn data_in_to_method_call() {
    let mn = MyFlag { flag: true };
    let a = source(1);
    mn.data_in(a)
}

fn data_through_method() {
    let mn = MyFlag { flag: true };
    let a = source(4);
    let b = mn.data_through(a);
    sink(b); // $ hasValueFlow=4
}

use std::ops::Add;

struct MyInt {
    value: i64,
}

impl Add for MyInt {
    type Output = MyInt;

    fn add(self, _other: MyInt) -> MyInt {
        // Ignore `_other` to get value flow for `self.value`
        MyInt { value: self.value }
    }
}

pub fn test_operator_overloading() {
    let a = MyInt { value: source(5) };
    let b = MyInt { value: 2 };
    let c = a + b;
    sink(c.value); // $ MISSING: hasValueFlow=5

    let a = MyInt { value: 2 };
    let b = MyInt { value: source(6) };
    let d = a + b;
    sink(d.value);

    let a = MyInt { value: source(7) };
    let b = MyInt { value: 2 };
    let d = a.add(b);
    sink(d.value); // $ MISSING: hasValueFlow=7
}

fn main() {
    data_out_of_call();
    data_in_to_call();
    data_through_call();
    data_through_nested_function();

    data_out_of_method();
    data_in_to_method_call();
    data_through_method();

    test_operator_overloading();
}
