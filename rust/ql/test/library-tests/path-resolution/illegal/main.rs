mod m1 {
    struct S(); // I1

    trait T1 {
        fn f1(&self);
    } // I2

    mod nested1 {

        trait T2 {
            fn f2(&self);
        } // I3

        #[rustfmt::skip]
        impl super::S { // $ item=I1
            fn f(self) {
                println!("m1::S::f");
            } // I4

            pub fn g(self) {
                println!("m1::S::f");
            } // I5
        }

        #[rustfmt::skip]
        impl super::T1 // $ item=I2
        for super::S { // $ item=I1
            fn f1(&self) {
                println!("m1::nested1::T2::f");
            } // I6
        }

        #[rustfmt::skip]
        impl T2 // $ item=I3
        for super::S { // $ item=I1
            fn f2(&self) {
                println!("m1::nested1::T2::f");
            } // I7
        }
    }

    mod nested2 {
        use super::nested1::T2; // illegal: private
        use super::T1; // $ item=I2

        #[rustfmt::skip]
        pub fn f() {
            println!("m1::nested2::f");
            super::S(). // $ item=I1
                f(); // $ SPURIOUS: item=I4 (private)
            super::S::f( // illegal: private
                super::S() // $ item=I1
            );
            super::S(). // $ item=I1
                g(); // $ item=I5
            super::S::g( // $ item=I5
                super::S() // $ item=I1
            );
            super::S(). // $ item=I1
                f1(); // $ item=I6
            super::S::f1( // $ MISSING: item=I6
                super::S() // $ item=I1
            );
            super::S(). // $ item=I1
                f2(); // $ SPURIOUS: item=I7 (private)
            super::S::f2(
                super::S() // $ item=I1
            ); // illegal: private
        }
    }
}
