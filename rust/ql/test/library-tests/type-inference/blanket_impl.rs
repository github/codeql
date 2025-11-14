// Tests for method resolution targeting blanket trait implementations

mod basic_blanket_impl {
    use std::ops::Deref;

    #[derive(Debug, Copy, Clone)]
    struct S1;

    #[derive(Debug, Copy, Clone)]
    struct S2;

    impl Deref for S2 {
        type Target = S1;

        fn deref(&self) -> &Self::Target {
            &S1
        }
    }

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

    // Blanket implementation for all types that implement Clone1
    impl<T: Clone1> Duplicatable for T {
        // Clone1duplicate
        fn duplicate(&self) -> Self {
            self.clone1() // $ target=clone1
        }
    }

    pub fn test_basic_blanket() {
        let x1 = S1.clone1(); // $ target=S1::clone1
        println!("{x1:?}");
        let x2 = (&S1).clone1(); // $ target=S1::clone1
        println!("{x2:?}");
        let x3 = S1.duplicate(); // $ target=Clone1duplicate
        println!("{x3:?}");
        let x4 = (&S1).duplicate(); // $ target=Clone1duplicate
        println!("{x4:?}");
        let x5 = S1::duplicate(&S1); // $ target=Clone1duplicate
        println!("{x5:?}");
        let x6 = S2.duplicate(); // $ MISSING: target=Clone1duplicate
        println!("{x6:?}");
        let x7 = (&S2).duplicate(); // $ MISSING: target=Clone1duplicate
        println!("{x7:?}");
    }
}

mod assoc_blanket_impl {
    #[derive(Debug, Copy, Clone)]
    struct S1;

    trait Trait1 {
        fn assoc_func1(x: i64, y: Self) -> Self;
    }

    trait Trait2 {
        fn assoc_func2(x: i64, y: Self) -> Self;
    }

    impl Trait1 for S1 {
        // S1::assoc_func1
        fn assoc_func1(x: i64, y: Self) -> Self {
            y
        }
    }

    impl<T: Trait1> Trait2 for T {
        // Blanket_assoc_func2
        fn assoc_func2(x: i64, y: Self) -> Self {
            T::assoc_func1(x, y) // $ target=assoc_func1
        }
    }

    pub fn test_assoc_blanket() {
        let x1 = S1::assoc_func1(1, S1); // $ target=S1::assoc_func1
        println!("{x1:?}");
        let x2 = Trait1::assoc_func1(1, S1); // $ target=S1::assoc_func1
        println!("{x2:?}");
        let x3 = S1::assoc_func2(1, S1); // $ target=Blanket_assoc_func2
        println!("{x3:?}");
        let x4 = Trait2::assoc_func2(1, S1); // $ target=Blanket_assoc_func2
        println!("{x4:?}");
    }
}

mod extension_trait_blanket_impl {
    // This tests:
    // 1. A trait that is implemented for a type parameter
    // 2. An extension trait
    // 3. A blanket implementation of the extension trait for a type parameter

    trait Flag {
        fn read_flag(&self) -> bool;
    }

    trait TryFlag {
        fn try_read_flag(&self) -> Option<bool>;
    }

    impl<Fl> TryFlag for Fl
    where
        Fl: Flag,
    {
        fn try_read_flag(&self) -> Option<bool> {
            Some(self.read_flag()) // $ target=read_flag
        }
    }

    trait TryFlagExt: TryFlag {
        // TryFlagExt::try_read_flag_twice
        fn try_read_flag_twice(&self) -> Option<bool> {
            self.try_read_flag() // $ target=try_read_flag
        }
    }

    impl<T: TryFlag> TryFlagExt for T {}

    trait AnotherTryFlag {
        // AnotherTryFlag::try_read_flag_twice
        fn try_read_flag_twice(&self) -> Option<bool>;
    }

    struct MyTryFlag {
        flag: bool,
    }

    impl TryFlag for MyTryFlag {
        // MyTryFlag::try_read_flag
        fn try_read_flag(&self) -> Option<bool> {
            Some(self.flag) // $ fieldof=MyTryFlag
        }
    }

    struct MyFlag {
        flag: bool,
    }

    impl Flag for MyFlag {
        // MyFlag::read_flag
        fn read_flag(&self) -> bool {
            self.flag // $ fieldof=MyFlag
        }
    }

    struct MyOtherFlag {
        flag: bool,
    }

    impl AnotherTryFlag for MyOtherFlag {
        // MyOtherFlag::try_read_flag_twice
        fn try_read_flag_twice(&self) -> Option<bool> {
            Some(self.flag) // $ fieldof=MyOtherFlag
        }
    }

    fn test() {
        let my_try_flag = MyTryFlag { flag: true };
        let result = my_try_flag.try_read_flag_twice(); // $ target=TryFlagExt::try_read_flag_twice

        let my_flag = MyFlag { flag: true };
        // Here `TryFlagExt::try_read_flag_twice` is a target since there is a
        // blanket implementaton of `TryFlag` for `Flag`.
        let result = my_flag.try_read_flag_twice(); // $ MISSING: target=TryFlagExt::try_read_flag_twice

        let my_other_flag = MyOtherFlag { flag: true };
        // Here `TryFlagExt::try_read_flag_twice` is _not_ a target since
        // `MyOtherFlag` does not implement `TryFlag`.
        let result = my_other_flag.try_read_flag_twice(); // $ target=MyOtherFlag::try_read_flag_twice
    }
}

mod blanket_like_impl {
    #[derive(Debug, Copy, Clone)]
    struct S1;

    #[derive(Debug, Copy, Clone)]
    struct S2;

    trait MyTrait1 {
        // MyTrait1::m1
        fn m1(self);
    }

    trait MyTrait2 {
        // MyTrait2::m2
        fn m2(self);
    }

    trait MyTrait3 {
        // MyTrait3::m3
        fn m3(self);
    }

    trait MyTrait4a {
        // MyTrait4a::m4
        fn m4(self);
    }

    trait MyTrait4b {
        // MyTrait4b::m4
        fn m4(self);
    }

    impl MyTrait1 for S1 {
        // S1::m1
        fn m1(self) {}
    }

    impl MyTrait3 for S1 {
        // S1::m3
        fn m3(self) {}
    }

    impl<T: MyTrait1 + Copy> MyTrait2 for &T {
        // MyTrait2Ref::m2
        fn m2(self) {
            self.m1() // $ target=MyTrait1::m1
        }
    }

    impl MyTrait2 for &&S1 {
        // MyTrait2RefRefS1::m2
        fn m2(self) {
            self.m1() // $ MISSING: target=S1::m1
        }
    }

    impl<T: MyTrait3> MyTrait4a for T {
        // MyTrait4aBlanket::m4
        fn m4(self) {
            self.m3() // $ target=MyTrait3::m3
        }
    }

    impl<T> MyTrait4b for &T {
        // MyTrait4bRef::m4
        fn m4(self) {}
    }

    pub fn test_basic_blanket() {
        let x1 = S1.m1(); // $ target=S1::m1
        let x2 = (&S1).m2(); // $ target=MyTrait2Ref::m2
        let x3 = (&&S1).m2(); // $ target=MyTrait2RefRefS1::m2
        let x4 = S1.m4(); // $ target=MyTrait4aBlanket::m4
        let x5 = (&S1).m4(); // $ target=MyTrait4bRef::m4
        let x6 = S2.m4(); // $ target=MyTrait4bRef::m4
        let x7 = (&S2).m4(); // $ target=MyTrait4bRef::m4
    }
}

pub mod sql_exec {
    // a highly simplified model of `MySqlConnection.execute` in SQLx

    trait Connection {}

    trait Executor {
        fn execute1(&self);
        fn execute2<E>(&self, query: E);
    }

    impl<T: Connection> Executor for T {
        fn execute1(&self) {
            println!("Executor::execute1");
        }

        fn execute2<E>(&self, _query: E) {
            println!("Executor::execute2");
        }
    }

    struct MySqlConnection {}

    impl Connection for MySqlConnection {}

    pub fn f() {
        let c = MySqlConnection {}; // $ certainType=c:MySqlConnection

        c.execute1(); // $ target=execute1
        MySqlConnection::execute1(&c); // $ target=execute1

        c.execute2("SELECT * FROM users"); // $ target=execute2
        c.execute2::<&str>("SELECT * FROM users"); // $ target=execute2
        MySqlConnection::execute2(&c, "SELECT * FROM users"); // $ target=execute2
        MySqlConnection::execute2::<&str>(&c, "SELECT * FROM users"); // $ target=execute2
    }
}
