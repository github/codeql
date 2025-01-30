mod m1 {
    pub struct Foo {}

    impl Foo {
        pub fn m(self) -> Self {
            self
        }
    }

    pub fn f() -> Foo {
        println!("main.rs::m1::f");
        let x = Foo {};
        let y: _ = Foo {};
        x
    }

    pub fn g(x: Foo) -> Foo {
        println!("main.rs::m1::g");
        x.m()
    }
}

mod m2 {
    struct MyThing<A> {
        a: A,
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    // As two separate methods

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

    // As two trait implementations

    trait MyTrait<A> {
        fn m2(self) -> A;
    }

    impl MyTrait<S1> for MyThing<S1> {
        fn m2(self) -> S1 {
            self.a
        }
    }

    impl MyTrait<Self> for MyThing<S2> {
        fn m2(self) -> Self {
            Self { a: self.a }
        }
    }

    fn call_trait<T1, T2: MyTrait<T1>>(x: T2) -> T1 {
        x.m2()
    }

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1());
        println!("{:?}", y.m1().a);

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", call_trait(x));
        println!("{:?}", call_trait(y).a);

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2());
        println!("{:?}", y.m2().a);
    }
}

mod m3 {
    trait MyTrait {
        type AssociatedType;

        fn m2(self) -> Self::AssociatedType;
    }

    #[derive(Debug)]
    struct S;

    impl MyTrait for S {
        type AssociatedType = S;

        fn m2(self) -> Self::AssociatedType {
            S
        }
    }

    pub fn f() {
        let x = S;

        println!("{:?}", x.m2());
    }
}

fn main() {
    m1::f();
    m1::g(m1::Foo {});
    m2::f();
    m3::f();
}
