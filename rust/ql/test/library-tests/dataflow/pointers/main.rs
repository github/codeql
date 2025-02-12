// -----------------------------------------------------------------------------
// Data flow through borrows and pointers.

fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
}

fn read_through_borrow() {
    let a = source(21);
    let b = &a;
    let c = *b;
    sink(c); // $ hasValueFlow=21
}

fn write_through_borrow() {
    let mut a = 1;
    sink(a);
    let b = &mut a;
    *b = source(39);
    sink(a); // $ MISSING: hasValueFlow=39
}

fn write_and_read_through_borrow() {
    let mut a = 12;
    let b = &mut a;
    sink(*b);
    *b = source(37);
    sink(*b); // $ hasValueFlow=37
    *b = 0;
    sink(*b); // now cleared
}

fn takes_borrowed_value(&n: &i64) {
    sink(n); // $ hasValueFlow=83
}

fn pass_borrowed_value() {
    let val = source(83);
    takes_borrowed_value(&val);
}

mod test_ref_pattern {
    use super::{sink, source};

    pub fn read_through_ref() {
        let a = source(21);
        let ref p = a;
        sink(*p); // $ hasValueFlow=21
    }

    pub fn write_through_ref_mut() {
        let ref mut a = source(78);
        sink(*a); // $ hasValueFlow=78
        *a = 0;
        sink(*a); // now cleared
    }

    pub fn ref_pattern_in_match() {
        let a = Some(source(17));
        let b = match a {
            Some(ref p) => sink(*p), // $ hasValueFlow=17
            None => (),
        };
    }
}

enum MyNumber {
    MyNumber(i64),
}

impl MyNumber {
    fn to_number(self) -> i64 {
        match self {
            MyNumber::MyNumber(number) => number,
        }
    }

    fn get_number(&self) -> i64 {
        match self {
            &MyNumber::MyNumber(number) => number,
        }
    }
}

fn through_self_in_method_no_borrow() {
    let my_number = MyNumber::MyNumber(source(33));
    sink(my_number.to_number()); // $ hasValueFlow=33
}

fn through_self_in_method_implicit_borrow() {
    let my_number = MyNumber::MyNumber(source(85));
    sink(my_number.get_number()); // $ MISSING: hasValueFlow=85
}

fn through_self_in_method_explicit_borrow() {
    let my_number = &MyNumber::MyNumber(source(40));
    sink(my_number.get_number()); // $ hasValueFlow=40
}

fn ref_nested_pattern_match() {
    let a = &(source(23), 1);

    // Match "in order", reference pattern then tuple pattern
    let b = match a {
        &(n, _) => n,
    };
    sink(b); // $ hasValueFlow=23

    // Match "out of order", tuple pattern then deref pattern
    let c = match a {
        (n, _) => match n {
            &i => i,
        },
    };
    sink(c); // $ MISSING: hasValueFlow=23
}

use test_ref_pattern::*;

fn main() {
    read_through_borrow();
    write_through_borrow();
    write_and_read_through_borrow();
    pass_borrowed_value();
    through_self_in_method_no_borrow();
    through_self_in_method_implicit_borrow();
    through_self_in_method_explicit_borrow();
    ref_nested_pattern_match();
    read_through_ref();
    write_through_ref_mut();
    ref_pattern_in_match();
}
