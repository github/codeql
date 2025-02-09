// summary=repo::test;crate::summaries::identity;Argument[0];ReturnValue;value;dfc-generated
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
    // summary=repo::test;<crate::summaries::Either>::new;Argument[0];ReturnValue.Variant[crate::summaries::Either::Right(0)];value;dfc-generated
    pub fn new(b: B) -> Self {
        Right(b)
    }

    // summary=repo::test;<crate::summaries::Either>::unwrap;Argument[self].Variant[crate::summaries::Either::Right(0)];ReturnValue;value;dfc-generated
    pub fn unwrap(self) -> B {
        match self {
            Left(a) => panic!("Left cannot be unwrapped"),
            Right(b) => b,
        }
    }

    // summary=repo::test;<crate::summaries::Either>::zip;Argument[0].Variant[crate::summaries::Either::Left(0)];ReturnValue.Variant[crate::summaries::Either::Left(0)];value;dfc-generated
    // summary=repo::test;<crate::summaries::Either>::zip;Argument[0].Variant[crate::summaries::Either::Right(0)];ReturnValue.Variant[crate::summaries::Either::Right(0)].Tuple[1];value;dfc-generated
    // summary=repo::test;<crate::summaries::Either>::zip;Argument[self].Variant[crate::summaries::Either::Left(0)];ReturnValue.Variant[crate::summaries::Either::Left(0)];value;dfc-generated
    // summary=repo::test;<crate::summaries::Either>::zip;Argument[self].Variant[crate::summaries::Either::Right(0)];ReturnValue.Variant[crate::summaries::Either::Right(0)].Tuple[0];value;dfc-generated
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
    // summary=repo::test;<crate::summaries::MyStruct>::new;Argument[0];ReturnValue.Struct[crate::summaries::MyStruct::foo];value;dfc-generated
    // summary=repo::test;<crate::summaries::MyStruct>::new;Argument[1];ReturnValue.Struct[crate::summaries::MyStruct::bar];value;dfc-generated
    pub fn new(a: i64, b: f64) -> MyStruct {
        MyStruct { foo: a, bar: b }
    }

    // summary=repo::test;<crate::summaries::MyStruct>::get_foo;Argument[self].Struct[crate::summaries::MyStruct::foo];ReturnValue;value;dfc-generated
    pub fn get_foo(self) -> i64 {
        match self {
            MyStruct { foo, bar: _ } => foo,
        }
    }

    // summary=repo::test;<crate::summaries::MyStruct>::get_bar;Argument[self].Struct[crate::summaries::MyStruct::bar];ReturnValue;value;dfc-generated
    pub fn get_bar(self) -> f64 {
        match self {
            MyStruct { foo: _, bar } => bar,
        }
    }
}

// Higher-order functions

// summary=repo::test;crate::summaries::apply;Argument[0];Argument[1].Parameter[0];value;dfc-generated
// summary=repo::test;crate::summaries::apply;Argument[1].ReturnValue;ReturnValue;value;dfc-generated
pub fn apply<F>(n: i64, f: F) -> i64 where F : FnOnce(i64) -> i64 {
    f(n)
}
