pub mod nested1 {
    pub mod nested2 {
        pub fn f() {
            println!("nested.rs:nested1::nested2::f"); // $ item=println
        } // I4

        fn g() {
            println!("nested.rs:nested1::nested2::g"); // $ item=println
            f(); // $ item=I4
        } // I5
    } // I3

    fn g() {
        println!("nested.rs:nested1::g"); // $ item=println
        nested2::f(); // $ item=I4
    } // I6
} // I1

pub fn g() {
    println!("nested.rs::g"); // $ item=println
    nested1::nested2::f(); // $ item=I4
} // I7
