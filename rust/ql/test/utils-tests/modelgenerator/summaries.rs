// summary=test::summaries::identity;Argument[0];ReturnValue;value;dfc-generated
pub fn identity<A>(a: A) -> A {
    a
}

// no summary since this function is not public.
fn identity_unexported<A>(a: A) -> A {
    a
}

pub enum Either<A, B> {
    Left(A),
    Right(B),
}

use Either::*;

impl<A, B> Either<A, B> {
    // summary=<test::summaries::Either>::new;Argument[0];ReturnValue.Field[test::summaries::Either::Right(0)];value;dfc-generated
    pub fn new(b: B) -> Self {
        Right(b)
    }

    // summary=<test::summaries::Either>::unwrap;Argument[self].Field[test::summaries::Either::Right(0)];ReturnValue;value;dfc-generated
    pub fn unwrap(self) -> B {
        match self {
            Left(a) => panic!("Left cannot be unwrapped"),
            Right(b) => b,
        }
    }

    // summary=<test::summaries::Either>::zip;Argument[0].Field[test::summaries::Either::Left(0)];ReturnValue.Field[test::summaries::Either::Left(0)];value;dfc-generated
    // summary=<test::summaries::Either>::zip;Argument[0].Field[test::summaries::Either::Right(0)];ReturnValue.Field[test::summaries::Either::Right(0)].Field[1];value;dfc-generated
    // summary=<test::summaries::Either>::zip;Argument[self].Field[test::summaries::Either::Left(0)];ReturnValue.Field[test::summaries::Either::Left(0)];value;dfc-generated
    // summary=<test::summaries::Either>::zip;Argument[self].Field[test::summaries::Either::Right(0)];ReturnValue.Field[test::summaries::Either::Right(0)].Field[0];value;dfc-generated
    pub fn zip<C>(self, other: Either<A, C>) -> Either<A, (B, C)> {
        match (self, other) {
            (Right(b), Right(d)) => Right((b, d)),
            (Left(a), _) => Left(a),
            (_, Left(a)) => Left(a),
        }
    }
}

pub struct MyStruct {
    foo: i64,
    bar: f64,
}

impl MyStruct {
    // summary=<test::summaries::MyStruct>::new;Argument[0];ReturnValue.Field[test::summaries::MyStruct::foo];value;dfc-generated
    // summary=<test::summaries::MyStruct>::new;Argument[1];ReturnValue.Field[test::summaries::MyStruct::bar];value;dfc-generated
    pub fn new(a: i64, b: f64) -> MyStruct {
        MyStruct { foo: a, bar: b }
    }

    // summary=<test::summaries::MyStruct>::get_foo;Argument[self].Field[test::summaries::MyStruct::foo];ReturnValue;value;dfc-generated
    pub fn get_foo(self) -> i64 {
        match self {
            MyStruct { foo, bar: _ } => foo,
        }
    }

    // summary=<test::summaries::MyStruct>::get_bar;Argument[self].Field[test::summaries::MyStruct::bar];ReturnValue;value;dfc-generated
    pub fn get_bar(self) -> f64 {
        match self {
            MyStruct { foo: _, bar } => bar,
        }
    }
}

// Higher-order functions

// summary=test::summaries::apply;Argument[0];Argument[1].Parameter[0];value;dfc-generated
// summary=test::summaries::apply;Argument[1].ReturnValue;ReturnValue;value;dfc-generated
pub fn apply<F>(n: i64, f: F) -> i64
where
    F: FnOnce(i64) -> i64,
{
    f(n)
}

// Flow out of mutated arguments

// summary=test::summaries::set_int;Argument[1];Argument[0].Reference;value;dfc-generated
pub fn set_int(n: &mut i64, c: i64) {
    *n = c;
}

// summary=test::summaries::read_int;Argument[0].Reference;ReturnValue;value;dfc-generated
pub fn read_int(n: &mut i64) -> i64 {
    *n
}
