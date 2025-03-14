mod m1 {
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

mod m2 {
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

        println!("{:?}", x.m1()); // missing call target
        println!("{:?}", y.m1().a); // missing call target

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2());
        println!("{:?}", y.m2());
    }
}

mod m3 {
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

mod m4 {
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

mod m5 {
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

mod m6 {
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

mod m7 {
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

mod m8 {
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

mod m9 {
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

mod m10 {

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

mod m11 {
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

mod m12 {
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

mod m13 {
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
    m1::f();
    m1::g(m1::Foo {}, m1::Foo {});
    m2::f();
    m3::f();
    m4::f();
    m5::f();
    m6::f();
    m7::f();
    m8::f();
    m9::f();
    m10::f();
    m11::f();
    m12::f();
    m13::f();
}
