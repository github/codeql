// Tests for method resolution targeting blanket trait implementations

mod basic_blanket_impl {
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

    // Blanket implementation for all types that implement Display and Clone
    impl<T: Clone1> Duplicatable for T {
        // Clone1duplicate
        fn duplicate(&self) -> Self {
            self.clone1() // $ target=clone1
        }
    }

    pub fn test_basic_blanket() {
        let x = S1.clone1(); // $ target=S1::clone1
        println!("{x:?}");
        let y = S1.duplicate(); // $ target=Clone1duplicate
        println!("{y:?}");
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
        MySqlConnection::execute1(&c); // $ MISSING: target=execute1

        c.execute2("SELECT * FROM users"); // $ target=execute2
        c.execute2::<&str>("SELECT * FROM users"); // $ target=execute2
        MySqlConnection::execute2(&c, "SELECT * FROM users"); // $ MISSING: target=execute2
        MySqlConnection::execute2::<&str>(&c, "SELECT * FROM users"); // $ MISSING: target=execute2
    }
}
