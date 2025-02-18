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

        println!("{:?}", x.m1()); // missing
        println!("{:?}", y.m1().a); // missing

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2()); // missing
        println!("{:?}", y.m2()); // missing
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
        x.m1() // `x.m1` missing type
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

        println!("{:?}", x.m1()); // missing
        println!("{:?}", y.m1().a); // missing

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", call_trait_m1(x)); // `call_trait_m1(x)` missing type
        println!("{:?}", call_trait_m1(y).a); // `call_trait_m1(y)` missing type
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

        fn m2(self) -> Self
        where
            Self: Sized,
        {
            self
        }
    }

    fn call_trait_m1<T1, T2: MyTrait<T1>>(x: T2) -> T1 {
        x.m1() // `x.m1` missing type
    }

    impl<T> MyTrait<T> for MyThing<T> {
        fn m1(self) -> T {
            self.a
        }
    }

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1()); // `x.m1` missing type
        println!("{:?}", y.m1()); // `y.m1` missing type

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", call_trait_m1(x)); // `call_trait_m1(x)` missing type
        println!("{:?}", call_trait_m1(y)); // `call_trait_m1(y)` missing type
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
        println!("{:?}", x.m2()); // `x.m2` missing type
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
                MyEnum::C1(a) => a,    // `a` missing type
                MyEnum::C2 { a } => a, // `a` missing type
            }
        }
    }

    pub fn f() {
        let x = MyEnum::C1(S1); // `MyEnum::C1(S1)` missing type at path 0
        let y = MyEnum::C2 { a: S2 }; // `MyEnum::C2 { a: S2 }` missing type at ""

        println!("{:?}", x.m1()); // `x.m1` missing type
        println!("{:?}", y.m1()); // `y`, `y.m1` missing type
    }
}

mod m7 {
    #[derive(Debug)]
    struct MyThing<A> {
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
                self.m1() // missing
            } else {
                Self::m1(self) // missing
            }
        }
    }

    impl<T> MyTrait1<T> for MyThing<T> {
        fn m1(self) -> T {
            self.a
        }
    }

    impl<T> MyTrait2<T> for MyThing<T> {}

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1()); // `x.m1` missing type
        println!("{:?}", y.m1()); // `y.m1` missing type

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2()); // `x.m1` missing type
        println!("{:?}", y.m2()); // `y.m1` missing type
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
}
