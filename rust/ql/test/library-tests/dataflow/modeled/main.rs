fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
}

// Flow through `clone` methods

fn option_clone() {
    let a = Some(source(88));
    sink(a.unwrap()); // $ hasValueFlow=88
    let b = a.clone();
    sink(b.unwrap()); // $ hasValueFlow=88
}

fn result_clone() {
    let a: Result<i64, i64> = Ok(source(37));
    sink(a.unwrap()); // $ hasValueFlow=37
    let b = a.clone();
    sink(b.unwrap()); // $ hasValueFlow=37
}

fn i64_clone() {
    let a = source(12);
    sink(a); // $ hasValueFlow=12
    let b = a.clone();
    sink(b); // $ hasValueFlow=12
}

mod my_clone {
    use super::{sink, source};

    #[derive(Clone)]
    struct Wrapper {
        n: i64,
    }

    pub fn wrapper_clone() {
        let w = Wrapper { n: source(73) };
        match w {
            Wrapper { n: n } => sink(n), // $ hasValueFlow=73
        }
        let u = w.clone();
        match u {
            Wrapper { n: n } => sink(n), // $ hasValueFlow=73
        }
    }
}

mod flow_through_option {
    use super::{sink, source};
    // Test the auto generated flow summaries for `Option`

    fn zip_flow() {
        let a = Some(2);
        let b = Some(source(38));
        let z = a.zip(b);
        match z {
            Some((n, m)) => {
                sink(n);
                sink(m); // $ hasValueFlow=38
            }
            None => (),
        }
    }

    fn higher_order_flow() {
        let a = Some(0);
        let b = a.map_or(3, |n| n + source(63));
        sink(b); // $ hasTaintFlow=63
    }
}

mod ptr {
    use super::{sink, source};

    fn read_write() {
        let mut x: i64 = 0;
        let y = &mut x as *mut i64;
        unsafe {
            sink(std::ptr::read(y));
            std::ptr::write(y, source(30));
            sink(std::ptr::read(y)); // $ hasValueFlow=30
        }
    }
}

use std::pin::Pin;
use std::pin::pin;

#[derive(Clone)]
struct MyStruct {
    val: i64,
}

fn test_pin() {
    {
        let mut i = source(40);
        let mut pin1 = Pin::new(&i);
        let mut pin2 = Box::pin(i);
        let mut pin3 = Box::into_pin(Box::new(i));
        let mut pin4 = pin!(i);
        sink(i); // $ hasValueFlow=40
        sink(*pin1); // $ hasValueFlow=40
        sink(*Pin::into_inner(pin1)); // $ hasValueFlow=40
        sink(*pin2); // $ hasValueFlow=40
        sink(*pin3); // $ hasValueFlow=40
        sink(*pin4); // $ MISSING: hasValueFlow=40
    }

    {
        let mut ms = MyStruct { val: source(41) };
        let mut pin1 = Pin::new(&ms);
        let mut pin2 = Box::pin(ms.clone());
        let mut pin3 = Box::into_pin(Box::new(ms.clone()));
        let mut pin4 = pin!(&ms);
        sink(ms.val); // $ hasValueFlow=41
        sink(pin1.val); // $ MISSING: hasValueFlow=41
        sink(Pin::into_inner(pin1).val); // $ MISSING: hasValueFlow=41
        sink(pin2.val); // $ MISSING: hasValueFlow=41
        sink(pin3.val); // $ MISSING: hasValueFlow=41
        sink(pin4.val); // $ MISSING: hasValueFlow=41
    }

    unsafe {
        let mut ms = MyStruct { val: source(42) };
        let mut pin5 = Pin::new_unchecked(&ms);
        sink(pin5.val); // $ MISSING: hasValueFlow=42
        sink(Pin::into_inner_unchecked(pin5).val); // $ MISSING: hasValueFlow=40
    }

    {
        let mut ms = MyStruct { val: source(43) };
        let mut ms2 = MyStruct { val: source(44) };
        let mut pin = Pin::new(&mut ms);
        sink(pin.val); // $ MISSING: hasValueFlow=43
        pin.set(ms2);
        sink(pin.val); // $ MISSING: hasValueFlow=44
    }
}

fn main() {
    option_clone();
    result_clone();
    i64_clone();
    my_clone::wrapper_clone();
    test_pin();
}
