// The code in this file is not valid Rust code

// test that our type inference implementation does not run into an infinite loop.
mod type_loop {
    struct S<T>(T);

    trait T1<T>: T2<S<T>> {
        fn foo(self) {}
    }

    trait T2<T>: T1<S<T>> {
        fn bar(self) {
            self.foo() // $ target=foo
        }
    }
}

mod op_blanket_impl {
    use std::ops::Add;

    #[derive(Debug, Copy, Clone)]
    struct Num(i32);

    trait AddAlias {
        fn add_alias(self, other: Self) -> Self;
    }

    impl AddAlias for Num {
        fn add_alias(self, other: Self) -> Self {
            Num(self.0 + other.0) // $ fieldof=Num $ target=add
        }
    }

    // this is not valid in Rust, because of coherence
    impl<T: AddAlias> Add for T {
        type Output = Self;

        // BlanketAdd
        fn add(self, other: Self) -> Self {
            self.add_alias(other) // $ target=add_alias
        }
    }

    pub fn test_op_blanket() {
        let a = Num(5);
        let b = Num(10);
        let c = a + b; // $ target=BlanketAdd
        println!("{c:?}");
    }
}

mod impl_specialization {
    #[derive(Debug, Copy, Clone)]
    struct S1;

    trait Clone1 {
        fn clone1(&self) -> Self;
    }

    trait Duplicatable {
        fn duplicate(&self) -> Self
        where
            Self: Sized;
    }

    impl Clone1 for S1 {
        // S1::clone1
        fn clone1(&self) -> Self {
            *self // $ target=deref
        }
    }

    impl Duplicatable for S1 {
        // S1::duplicate
        fn duplicate(&self) -> Self {
            *self // $ target=deref
        }
    }

    // Blanket implementation for all types that implement Clone1
    impl<T: Clone1> Duplicatable for T {
        // Clone1duplicate
        fn duplicate(&self) -> Self {
            self.clone1() // $ target=clone1
        }
    }

    pub fn test_basic_blanket() {
        // this call should target the specialized implementation of Duplicatable for S1,
        // not the blanket implementation
        let x = S1.duplicate(); // $ target=S1::duplicate
    }
}
