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

struct MyStruct {
    data: i64,
}

impl MyStruct {
    fn set_data(&mut self, n: i64) {
        (*self).data = n // todo: implicit deref not yet supported
    }

    fn get_data(&self) -> i64 {
        (*self).data // todo: implicit deref not yet supported
    }
}

fn data_out_of_call_side_effect1() {
    let mut a = MyStruct { data: 0 };
    sink(a.get_data());
    (&mut a).set_data(source(8));
    sink(a.get_data()); // $ hasValueFlow=8
}

fn data_out_of_call_side_effect2() {
    let mut a = MyStruct { data: 0 };
    ({
        42;
        &mut a
    })
    .set_data(source(9));
    sink(a.get_data()); // $ hasValueFlow=9
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

trait MyTrait {
    fn data_in_trait(self, n: i64);
    fn get_data_trait(self) -> i64;
    fn data_through_trait(self, n: i64) -> i64;
}

impl MyFlag {
    fn data_in(self, n: i64) {
        sink(n); // $ hasValueFlow=1 hasValueFlow=8
    }

    fn get_data(self) -> i64 {
        if self.flag { 0 } else { source(2) }
    }

    fn data_through(self, n: i64) -> i64 {
        if self.flag { 0 } else { n }
    }
}

impl MyTrait for MyFlag {
    fn data_in_trait(self, n: i64) {
        sink(n); // $ hasValueFlow=22 $ hasValueFlow=31
    }

    fn get_data_trait(self) -> i64 {
        if self.flag { 0 } else { source(21) }
    }

    fn data_through_trait(self, n: i64) -> i64 {
        if self.flag { 0 } else { n }
    }
}

fn data_out_of_method_trait_dispatch<T: MyTrait>(x: T) {
    let a = x.get_data_trait();
    sink(a); // $ hasValueFlow=21
}

fn data_out_of_method() {
    let mn = MyFlag { flag: true };
    let a = mn.get_data();
    sink(a); // $ hasValueFlow=2

    let mn = MyFlag { flag: true };
    let a = mn.get_data_trait();
    sink(a); // $ hasValueFlow=21

    data_out_of_method_trait_dispatch(MyFlag { flag: true });
}

fn data_in_to_method_call_trait_dispatch<T: MyTrait>(x: T) {
    let a = source(31);
    x.data_in_trait(a);
}

fn data_in_to_method_call() {
    let mn = MyFlag { flag: true };
    let a = source(1);
    mn.data_in(a);

    let mn = MyFlag { flag: true };
    let a = source(22);
    mn.data_in_trait(a);

    data_in_to_method_call_trait_dispatch(MyFlag { flag: true });
}

fn data_through_method_trait_dispatch<T: MyTrait>(x: T) {
    let a = source(34);
    let b = x.data_through_trait(a);
    sink(b); // $ hasValueFlow=34
}

fn data_through_method() {
    let mn = MyFlag { flag: true };
    let a = source(4);
    let b = mn.data_through(a);
    sink(b); // $ hasValueFlow=4

    let mn = MyFlag { flag: true };
    let a = source(24);
    let b = mn.data_through_trait(a);
    sink(b); // $ hasValueFlow=24

    data_through_method_trait_dispatch(MyFlag { flag: true });
}

fn data_in_to_method_called_as_function() {
    let mn = MyFlag { flag: true };
    let a = source(8);
    MyFlag::data_in(mn, a);
}

fn data_through_method_called_as_function() {
    let mn = MyFlag { flag: true };
    let a = source(12);
    let b = MyFlag::data_through(mn, a);
    sink(b); // $ hasValueFlow=12
}

use std::ops::{Add, Deref, MulAssign};

struct MyInt {
    value: i64,
}

impl MyInt {
    // Associated function
    fn new(n: i64) -> Self {
        MyInt { value: n }
    }
}

fn data_through_associated_function() {
    let n = MyInt::new(source(34));
    let MyInt { value: m } = n;
    sink(m); // $ hasValueFlow=34
}

impl Add for MyInt {
    type Output = MyInt;

    fn add(self, _other: MyInt) -> MyInt {
        // Ignore `_other` to get value flow for `self.value`
        MyInt { value: self.value }
    }
}

impl MulAssign<MyInt> for MyInt {
    fn mul_assign(&mut self, rhs: MyInt) {
        (*self).value = rhs.value; // todo: implicit deref not yet supported
    }
}

impl Deref for MyInt {
    type Target = i64;

    fn deref(&self) -> &Self::Target {
        &(*self).value
    }
}

fn test_operator_overloading() {
    // Tests for simple binary operator.
    let a = MyInt { value: source(5) };
    let b = MyInt { value: 2 };
    let c = a + b;
    sink(c.value); // $ hasValueFlow=5

    let a = MyInt { value: 2 };
    let b = MyInt { value: source(6) };
    let d = a + b;
    sink(d.value);

    let a = MyInt { value: source(7) };
    let b = MyInt { value: 2 };
    let d = a.add(b);
    sink(d.value); // $ hasValueFlow=7

    // Tests for assignment operator.
    let mut a = MyInt { value: 0 };
    let b = MyInt { value: source(34) };
    // The line below is what `*=` desugars to.
    MulAssign::mul_assign(&mut a, b);
    sink(a.value); // $ hasValueFlow=34

    let mut a = MyInt { value: 0 };
    let b = MyInt { value: source(35) };
    a *= b;
    sink(a.value); // $ MISSING: hasValueFlow=35

    // Tests for deref operator.
    let a = MyInt { value: source(27) };
    // The line below is what the prefix `*` desugars to.
    let c = *Deref::deref(&a);
    sink(c); // $ MISSING: hasValueFlow=27

    let a = MyInt { value: source(28) };
    let c = *a;
    sink(c); // $ hasTaintFlow=28 MISSING: hasValueFlow=28
}

trait MyTrait2 {
    type Output;
    fn take_self(self, _other: Self::Output) -> Self::Output;
    fn take_second(self, other: Self::Output) -> Self::Output;
}

impl MyTrait2 for MyInt {
    type Output = MyInt;

    fn take_self(self, _other: MyInt) -> MyInt {
        self
    }

    fn take_second(self, other: MyInt) -> MyInt {
        other
    }
}

fn data_through_trait_method_called_as_function() {
    let a = MyInt { value: source(8) };
    let b = MyInt { value: 2 };
    let MyInt { value: c } = MyTrait2::take_self(a, b);
    sink(c); // $ hasValueFlow=8

    let a = MyInt { value: 0 };
    let b = MyInt { value: source(37) };
    let MyInt { value: c } = MyTrait2::take_second(a, b);
    sink(c); // $ hasValueFlow=37

    let a = MyInt { value: 0 };
    let b = MyInt { value: source(38) };
    let MyInt { value: c } = MyTrait2::take_self(a, b);
    sink(c);
}

async fn async_source() -> i64 {
    let a = source(1);
    sink(a); // $ hasValueFlow=1
    a
}

async fn test_async_await_async_part() {
    let a = async_source().await;
    sink(a); // $ MISSING: hasValueFlow=1

    let b = async {
        let c = source(2);
        sink(c); // $ hasValueFlow=2
        c
    };
    sink(b.await); // $ MISSING: hasValueFlow=2
}

fn test_async_await() {
    let a = futures::executor::block_on(async_source());
    sink(a); // $ hasValueFlow=1

    futures::executor::block_on(test_async_await_async_part());
}

fn main() {
    data_out_of_call();
    data_out_of_call_side_effect1();
    data_out_of_call_side_effect2();
    data_in_to_call();
    data_through_call();
    data_through_nested_function();

    data_out_of_method();
    data_in_to_method_call();
    data_through_method();

    test_operator_overloading();
    test_async_await();
}
