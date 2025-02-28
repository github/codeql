// -----------------------------------------------------------------------------
// Data flow through borrows and pointers.

fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
}

// Intraprocedural tests involving immutable borrows
mod intraprocedural_immutable_borrows {
    use super::{sink, source};

    pub fn read_through_borrow() {
        let a = source(21);
        let b = &a;
        let c = *b;
        sink(c); // $ hasValueFlow=21
    }

    fn takes_borrowed_value(&n: &i64) {
        sink(n); // $ hasValueFlow=83
    }

    pub fn pass_borrowed_value() {
        let val = source(83);
        takes_borrowed_value(&val);
    }

    pub fn ref_nested_pattern_match() {
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

    pub fn read_through_ref_pattern() {
        let a = source(21);
        let ref p = a;
        sink(*p); // $ hasValueFlow=21
    }

    pub fn ref_pattern_in_match() {
        let a = Some(source(17));
        match a {
            Some(ref p) => sink(*p), // $ hasValueFlow=17
            None => (),
        };
    }
}

// Intraprocedural tests involving mutable borrows
mod intraprocedural_mutable_borrows {
    use super::{sink, source};

    pub fn write_and_read_through_borrow() {
        let mut a = 12;
        let b = &mut a;
        sink(*b);
        *b = source(37);
        sink(*b); // $ hasValueFlow=37
        *b = 0;
        sink(*b); // now cleared
    }

    pub fn write_through_borrow() {
        let mut a = 1;
        sink(a);
        let b = &mut a;
        *b = source(39);
        sink(a); // $ MISSING: hasValueFlow=39
    }

    pub fn write_borrow_directly() {
        let mut a = 1;
        sink(a);
        *(&mut a) = source(87);
        sink(a); // $ MISSING: hasValueFlow=87
    }

    pub fn clear_through_borrow() {
        let mut to_be_cleared = source(34);
        let p = &mut to_be_cleared;
        *p = 0;
        sink(to_be_cleared); // variable is cleared
    }

    pub fn write_through_borrow_in_match(cond: bool) {
        let mut a = 1;
        let mut b = 2;
        let c = if cond { &mut a } else { &mut b };
        *c = source(24);
        sink(*c); // $ hasValueFlow=24
        sink(a); // $ MISSING: hasValueFlow=24
        sink(b); // $ MISSING: hasValueFlow=24
    }

    pub fn write_through_ref_mut() {
        let ref mut a = source(78);
        sink(*a); // $ hasValueFlow=78
        *a = 0;
        sink(*a); // now cleared
    }

    pub fn mutate_tuple() {
        let mut t = (1, 2, 3);
        sink(t.1);
        let r = &mut t.1;
        *r = source(48);
        sink(t.1); // $ MISSING: hasValueFlow=48
        let r = &mut t.1;
        *r = 0;
        sink(t.1); // now cleared
    }

    pub fn tuple_match_mut() {
        let mut a = (0, 1);
        sink(a.0);
        sink(a.1);
        match a {
            (ref mut x, ref mut y) => {
                *x = source(71);
                *y = 2;
            }
        }
        sink(a.0); // $ MISSING: hasValueFlow=71
        sink(a.1);
    }
}

#[derive(Copy, Clone)]
enum MyNumber {
    MyNumber(i64),
}

fn to_number(m: MyNumber) -> i64 {
    match m {
        MyNumber::MyNumber(number) => number,
    }
}

impl MyNumber {
    fn to_number(self) -> i64 {
        match self {
            MyNumber::MyNumber(number) => number,
        }
    }

    fn get(&self) -> i64 {
        match self {
            &MyNumber::MyNumber(number) => number,
        }
    }
}

// Interprocedural tests involving immutable borrows
mod interprocedural_immutable_borrows {
    use super::*;

    pub fn through_self_in_method_no_borrow() {
        let my_number = MyNumber::MyNumber(source(33));
        sink(my_number.to_number()); // $ hasValueFlow=33
    }

    pub fn through_self_in_method_explicit_borrow() {
        let my_number = MyNumber::MyNumber(source(40));
        sink((&my_number).get()); // $ hasValueFlow=40
    }

    pub fn through_self_in_method_implicit_borrow() {
        let my_number = MyNumber::MyNumber(source(85));
        // Implicit borrow
        sink(my_number.get()); // $ hasValueFlow=85
    }

    pub fn through_self_in_method_implicit_deref() {
        let my_number = &MyNumber::MyNumber(source(58));
        // Implicit dereference
        sink(my_number.to_number()); // $ hasValueFlow=58
    }
}

// Interprocedural tests involving mutable borrows
mod interprocedural_mutable_borrows {
    use super::*;

    fn set_int(n: &mut i64, value: i64) {
        *n = value;
    }

    pub fn mutates_existing_borrow() {
        // Passing an already borrowed value to a function and then reading from
        // the same borrow.
        let mut n = 0;
        let p = &mut n;
        sink(*p);
        set_int(p, source(38));
        sink(*p); // $ hasValueFlow=38
    }

    pub fn mutate_primitive_through_function() {
        // Borrowing at the call and then reading from the unborrowed variable.
        let mut n = 0;
        sink(n);
        set_int(&mut n, source(55));
        sink(n); // $ hasValueFlow=55
    }

    impl MyNumber {
        fn set(&mut self, number: i64) {
            *self = MyNumber::MyNumber(number);
        }
    }

    fn set_number(n: &mut MyNumber, number: i64) {
        *n = MyNumber::MyNumber(number);
    }

    pub fn mutate_enum_through_function() {
        let mut my_number = MyNumber::MyNumber(0);
        set_number(&mut my_number, source(64));
        sink(my_number.get()); // $ hasValueFlow=64
        set_number(&mut my_number, 0);
        sink(my_number.get()); // $ SPURIOUS: hasValueFlow=64
    }

    pub fn mutate_enum_through_method_implicit_borrow() {
        let mut my_number = MyNumber::MyNumber(0);
        // Implicit borrow.
        my_number.set(source(45));
        sink(to_number(my_number)); // $ hasValueFlow=45
        my_number.set(0);
        sink(to_number(my_number)); // $ SPURIOUS: hasValueFlow=45
    }

    pub fn mutate_enum_through_method_explicit_borrow() {
        let mut my_number = MyNumber::MyNumber(0);
        // Explicit borrow.
        (&mut my_number).set(source(99));
        sink(to_number(my_number)); // $ hasValueFlow=99
        (&mut my_number).set(0);
        sink(to_number(my_number)); // $ SPURIOUS: hasValueFlow=99
    }
}

use interprocedural_immutable_borrows::*;
use interprocedural_mutable_borrows::*;
use intraprocedural_immutable_borrows::*;
use intraprocedural_mutable_borrows::*;

fn main() {
    read_through_borrow();
    write_through_borrow();
    write_borrow_directly();
    clear_through_borrow();
    write_through_borrow_in_match(true);
    write_and_read_through_borrow();
    pass_borrowed_value();
    through_self_in_method_no_borrow();
    through_self_in_method_explicit_borrow();
    through_self_in_method_implicit_borrow();
    through_self_in_method_implicit_deref();
    mutates_existing_borrow();
    mutate_primitive_through_function();
    mutate_enum_through_function();
    mutate_enum_through_method_implicit_borrow();
    mutate_enum_through_method_explicit_borrow();
    ref_nested_pattern_match();
    read_through_ref_pattern();
    write_through_ref_mut();
    ref_pattern_in_match();
    mutate_tuple();
    tuple_match_mut();
}
