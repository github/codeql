mod field_access {
    #[derive(Debug)]
    struct S;

    #[derive(Debug)]
    struct MyThing {
        a: S,
    }

    #[derive(Debug)]
    enum MyOption<T> {
        MyNone(),
        MySome(T),
    }

    #[derive(Debug)]
    struct GenericThing<A> {
        a: A,
    }

    struct OptionS {
        a: MyOption<S>,
    }

    fn simple_field_access() {
        let x = MyThing { a: S };
        println!("{:?}", x.a);
    }

    fn generic_field_access() {
        // Explicit type argument
        let x = GenericThing::<S> { a: S };
        println!("{:?}", x.a);

        // Implicit type argument
        let y = GenericThing { a: S };
        println!("{:?}", x.a);

        // The type of the field `a` can only be infered from the concrete type
        // in the struct declaration.
        let x = OptionS {
            a: MyOption::MyNone(),
        };
        println!("{:?}", x.a);

        // The type of the field `a` can only be infered from the type argument
        let x = GenericThing::<MyOption<S>> {
            a: MyOption::MyNone(),
        };
        println!("{:?}", x.a);

        let mut x = GenericThing {
            a: MyOption::MyNone(),
        };
        // Only after this access can we infer the type parameter of `x`
        let a: MyOption<S> = x.a;
        println!("{:?}", a);
    }

    pub fn f() {
        simple_field_access();
        generic_field_access();
    }
}

mod method_impl {
    pub struct Foo {}

    impl Foo {
        pub fn m1(self) -> Self {
            self
        }

        pub fn m2(self) -> Foo {
            self
        }
    }

    pub fn f() -> Foo {
        println!("main.rs::m1::f");
        let x = Foo {};
        let y: _ = Foo {};
        x
    }

    pub fn g(x: Foo, y: Foo) -> Foo {
        println!("main.rs::m1::g");
        x.m1();
        y.m2()
    }
}

mod method_non_parametric_impl {
    #[derive(Debug)]
    struct MyThing<A> {
        a: A,
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    impl MyThing<S1> {
        fn m1(self) -> S1 {
            self.a
        }
    }

    impl MyThing<S2> {
        fn m1(self) -> Self {
            Self { a: self.a }
        }
    }

    impl<T> MyThing<T> {
        fn m2(self) -> T {
            self.a
        }
    }

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        // simple field access
        println!("{:?}", x.a);
        println!("{:?}", y.a);

        println!("{:?}", x.m1()); // missing call target
        println!("{:?}", y.m1().a); // missing call target

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2());
        println!("{:?}", y.m2());
    }
}

mod method_non_parametric_trait_impl {
    #[derive(Debug)]
    struct MyThing<A> {
        a: A,
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    trait MyTrait<A> {
        fn m1(self) -> A;

        fn m2(self) -> Self
        where
            Self: Sized,
        {
            self
        }
    }

    fn call_trait_m1<T1, T2: MyTrait<T1>>(x: T2) -> T1 {
        x.m1()
    }

    impl MyTrait<S1> for MyThing<S1> {
        fn m1(self) -> S1 {
            self.a
        }
    }

    impl MyTrait<Self> for MyThing<S2> {
        fn m1(self) -> Self {
            Self { a: self.a }
        }
    }

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1()); // missing call target
        println!("{:?}", y.m1().a); // missing call target

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", call_trait_m1(x)); // missing
        println!("{:?}", call_trait_m1(y).a); // missing
    }
}

mod type_parameter_bounds {
    use std::fmt::Debug;

    #[derive(Debug)]
    struct S1;

    #[derive(Debug)]
    struct S2;

    // Two traits with the same method name.

    trait FirstTrait<FT> {
        fn method(self) -> FT;
    }

    trait SecondTrait<ST> {
        fn method(self) -> ST;
    }

    fn call_first_trait_per_bound<I: Debug, T: SecondTrait<I>>(x: T) {
        // The type parameter bound determines which method this call is resolved to.
        let s1 = x.method(); // missing type for `s1`
        println!("{:?}", s1);
    }

    fn call_second_trait_per_bound<I: Debug, T: SecondTrait<I>>(x: T) {
        // The type parameter bound determines which method this call is resolved to.
        let s2 = x.method(); // missing type for `s2`
        println!("{:?}", s2);
    }

    fn trait_bound_with_type<T: FirstTrait<S1>>(x: T) {
        let s = x.method(); // missing type for `s`
        println!("{:?}", s);
    }

    fn trait_per_bound_with_type<T: FirstTrait<S1>>(x: T) {
        let s = x.method(); // missing type for `s`
        println!("{:?}", s);
    }

    trait Pair<P1, P2> {
        fn fst(self) -> P1;

        fn snd(self) -> P2;
    }

    fn call_trait_per_bound_with_type_1<T: Pair<S1, S2>>(x: T, y: T) {
        // The type in the type parameter bound determines the return type.
        let s1 = x.fst(); // missing type for `s1`
        let s2 = y.snd(); // missing type for `s2`
        println!("{:?}, {:?}", s1, s2);
    }

    fn call_trait_per_bound_with_type_2<T2: Debug, T: Pair<S1, T2>>(x: T, y: T) {
        // The type in the type parameter bound determines the return type.
        let s1 = x.fst(); // missing type for `s1`
        let s2 = y.snd(); // missing type for `s2`
        println!("{:?}, {:?}", s1, s2);
    }
}

mod function_trait_bounds {
    #[derive(Debug)]
    struct MyThing<A> {
        a: A,
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    trait MyTrait<A> {
        fn m1(self) -> A;

        fn m2(self) -> A
        where
            Self: Sized,
        {
            self.m1()
        }
    }

    fn call_trait_m1<T1, T2: MyTrait<T1>>(x: T2) -> T1 {
        x.m1()
    }

    impl<T> MyTrait<T> for MyThing<T> {
        fn m1(self) -> T {
            self.a
        }
    }

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1());
        println!("{:?}", y.m1());

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2());
        println!("{:?}", y.m2());

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", call_trait_m1(x)); // missing
        println!("{:?}", call_trait_m1(y)); // missing
    }
}

mod trait_associated_type {
    trait MyTrait {
        type AssociatedType;

        fn m1(self) -> Self::AssociatedType;

        fn m2(self) -> Self::AssociatedType
        where
            Self::AssociatedType: Default,
            Self: Sized,
        {
            Self::AssociatedType::default()
        }
    }

    #[derive(Debug, Default)]
    struct S;

    impl MyTrait for S {
        type AssociatedType = S;

        fn m1(self) -> Self::AssociatedType {
            S
        }
    }

    pub fn f() {
        let x = S;
        println!("{:?}", x.m1());

        let x = S;
        println!("{:?}", x.m2()); // missing
    }
}

mod generic_enum {
    #[derive(Debug)]
    enum MyEnum<A> {
        C1(A),
        C2 { a: A },
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    impl<T> MyEnum<T> {
        fn m1(self) -> T {
            match self {
                MyEnum::C1(a) => a,
                MyEnum::C2 { a } => a,
            }
        }
    }

    pub fn f() {
        let x = MyEnum::C1(S1);
        let y = MyEnum::C2 { a: S2 };

        println!("{:?}", x.m1());
        println!("{:?}", y.m1());
    }
}

mod method_supertraits {
    #[derive(Debug)]
    struct MyThing<A> {
        a: A,
    }

    #[derive(Debug)]
    struct MyThing2<A> {
        a: A,
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    trait MyTrait1<A> {
        fn m1(self) -> A;
    }

    trait MyTrait2<A>: MyTrait1<A> {
        fn m2(self) -> A
        where
            Self: Sized,
        {
            if 1 + 1 > 2 {
                self.m1()
            } else {
                Self::m1(self)
            }
        }
    }

    trait MyTrait3<A>: MyTrait2<MyThing<A>> {
        fn m3(self) -> A
        where
            Self: Sized,
        {
            if 1 + 1 > 2 {
                self.m2().a
            } else {
                Self::m2(self).a
            }
        }
    }

    impl<T> MyTrait1<T> for MyThing<T> {
        fn m1(self) -> T {
            self.a
        }
    }

    impl<T> MyTrait2<T> for MyThing<T> {}

    impl<T> MyTrait1<MyThing<T>> for MyThing2<T> {
        fn m1(self) -> MyThing<T> {
            MyThing { a: self.a }
        }
    }

    impl<T> MyTrait2<MyThing<T>> for MyThing2<T> {}

    impl<T> MyTrait3<T> for MyThing2<T> {}

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1());
        println!("{:?}", y.m1());

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2());
        println!("{:?}", y.m2());

        let x = MyThing2 { a: S1 };
        let y = MyThing2 { a: S2 };

        println!("{:?}", x.m3());
        println!("{:?}", y.m3());
    }
}

mod function_trait_bounds_2 {
    use std::convert::From;
    use std::fmt::Debug;

    #[derive(Debug)]
    struct S1;

    #[derive(Debug)]
    struct S2;

    trait Trait: Debug {}

    impl Trait for S1 {}

    fn id<T: ?Sized>(x: &T) -> &T {
        x
    }

    impl Into<S2> for S1 {
        fn into(self) -> S2 {
            S2
        }
    }

    fn into<T1, T2>(x: T1) -> T2
    where
        T1: Into<T2>,
    {
        x.into()
    }

    pub fn f() {
        let x = S1;
        println!("{:?}", id(&x));

        let x = S1;
        println!("{:?}", id::<S1>(&x));

        let x = S1;
        println!("{:?}", id::<dyn Trait>(&x)); // incorrectly has type `S1` instead of `Trait`

        let x = S1;
        into::<S1, S2>(x);

        let x = S1;
        let y: S2 = into(x);
    }
}

mod type_aliases {
    #[derive(Debug)]
    enum PairOption<Fst, Snd> {
        PairNone(),
        PairFst(Fst),
        PairSnd(Snd),
        PairBoth(Fst, Snd),
    }

    #[derive(Debug)]
    struct S1;

    #[derive(Debug)]
    struct S2;

    #[derive(Debug)]
    struct S3;

    // Non-generic type alias that fully applies the generic type
    type MyPair = PairOption<S1, S2>;

    // Generic type alias that partially applies the generic type
    type AnotherPair<Thr> = PairOption<S2, Thr>;

    pub fn f() {
        // Type can be infered from the constructor
        let p1: MyPair = PairOption::PairBoth(S1, S2);
        println!("{:?}", p1);

        // Type can be only infered from the type alias
        let p2: MyPair = PairOption::PairNone(); // types for `Fst` and `Snd` missing
        println!("{:?}", p2);

        // First type from alias, second from constructor
        let p3: AnotherPair<_> = PairOption::PairSnd(S3); // type for `Fst` missing
        println!("{:?}", p3);

        // First type from alias definition, second from argument to alias
        let p3: AnotherPair<S3> = PairOption::PairNone(); // type for `Snd` missing, spurious `S3` for `Fst`
        println!("{:?}", p3);
    }
}

mod option_methods {
    #[derive(Debug)]
    enum MyOption<T> {
        MyNone(),
        MySome(T),
    }

    trait MyTrait<S> {
        fn set(&mut self, value: S);

        fn call_set(&mut self, value: S) {
            self.set(value);
        }
    }

    impl<T> MyTrait<T> for MyOption<T> {
        fn set(&mut self, value: T) {}
    }

    impl<T> MyOption<T> {
        fn new() -> Self {
            MyOption::MyNone()
        }
    }

    impl<T> MyOption<MyOption<T>> {
        fn flatten(self) -> MyOption<T> {
            match self {
                MyOption::MyNone() => MyOption::MyNone(),
                MyOption::MySome(x) => x,
            }
        }
    }

    #[derive(Debug)]
    struct S;

    pub fn f() {
        let x1 = MyOption::<S>::new(); // `::new` missing type `S`
        println!("{:?}", x1);

        let mut x2 = MyOption::new();
        x2.set(S);
        println!("{:?}", x2);

        let mut x3 = MyOption::new(); // missing type `S` from `MyOption<S>` (but can resolve `MyTrait<S>`)
        x3.call_set(S);
        println!("{:?}", x3);

        let mut x4 = MyOption::new();
        MyOption::set(&mut x4, S);
        println!("{:?}", x4);

        let x5 = MyOption::MySome(MyOption::<S>::MyNone());
        println!("{:?}", x5.flatten()); // missing call target

        let x6 = MyOption::MySome(MyOption::<S>::MyNone());
        println!("{:?}", MyOption::<MyOption<S>>::flatten(x6));

        let from_if = if 1 + 1 > 2 {
            MyOption::MyNone()
        } else {
            MyOption::MySome(S)
        };
        println!("{:?}", from_if);

        let from_match = match 1 + 1 > 2 {
            true => MyOption::MyNone(),
            false => MyOption::MySome(S),
        };
        println!("{:?}", from_match);

        let from_loop = loop {
            if 1 + 1 > 2 {
                break MyOption::MyNone();
            }
            break MyOption::MySome(S);
        };
        println!("{:?}", from_loop);
    }
}

mod method_call_type_conversion {

    #[derive(Debug, Copy, Clone)]
    struct S<T>(T);

    #[derive(Debug, Copy, Clone)]
    struct S2;

    impl<T> S<T> {
        fn m1(self) -> T {
            self.0
        }

        fn m2(&self) -> &T {
            &self.0
        }

        fn m3(self: &S<T>) -> &T {
            &self.0
        }
    }

    pub fn f() {
        let x1 = S(S2);
        println!("{:?}", x1.m1());

        let x2 = S(S2);
        // implicit borrow
        println!("{:?}", x2.m2());
        println!("{:?}", x2.m3());

        let x3 = S(S2);
        // explicit borrow
        println!("{:?}", S::<S2>::m2(&x3));
        println!("{:?}", S::<S2>::m3(&x3));

        let x4 = &S(S2);
        // explicit borrow
        println!("{:?}", x4.m2());
        println!("{:?}", x4.m3());

        let x5 = &S(S2);
        // implicit dereference
        println!("{:?}", x5.m1());
        println!("{:?}", x5.0);

        let x6 = &S(S2);
        // explicit dereference
        println!("{:?}", (*x6).m1());
    }
}

mod trait_implicit_self_borrow {
    trait MyTrait {
        fn foo(&self) -> &Self;

        fn bar(&self) -> &Self {
            self.foo()
        }
    }

    struct MyStruct;

    impl MyTrait for MyStruct {
        fn foo(&self) -> &MyStruct {
            self
        }
    }

    pub fn f() {
        let x = MyStruct;
        x.bar();
    }
}

mod implicit_self_borrow {
    struct S;

    struct MyStruct<T>(T);

    impl<T> MyStruct<T> {
        fn foo(&self) -> &Self {
            self
        }
    }

    pub fn f() {
        let x = MyStruct(S);
        x.foo();
    }
}

mod borrowed_typed {
    struct S;

    impl S {
        fn f1(&self) -> &Self {
            &&&self
        }

        fn f2(self: &Self) -> &Self {
            &&&self
        }

        fn f3(x: &Self) -> &Self {
            x
        }

        fn f4(x: &Self) -> &Self {
            &&&x
        }
    }

    pub fn f() {
        let x = S {};
        x.f1();
        x.f2();
        S::f3(&x);
    }
}

fn main() {
    field_access::f();
    method_impl::f();
    method_impl::g(method_impl::Foo {}, method_impl::Foo {});
    method_non_parametric_impl::f();
    method_non_parametric_trait_impl::f();
    function_trait_bounds::f();
    trait_associated_type::f();
    generic_enum::f();
    method_supertraits::f();
    function_trait_bounds_2::f();
    option_methods::f();
    method_call_type_conversion::f();
    trait_implicit_self_borrow::f();
    implicit_self_borrow::f();
    borrowed_typed::f();
}
