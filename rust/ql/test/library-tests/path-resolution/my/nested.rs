pub mod nested1 {
    pub mod nested2 {
        pub fn f() {
            println!("nested.rs:nested1::nested2::f");
        } // I4

        fn g() {
            println!("nested.rs:nested1::nested2::g");
            f(); // $ item=I4
        } // I5
    } // I3

    fn g() {
        println!("nested.rs:nested1::g");
        nested2::f(); // $ item=I4
    } // I6
} // I1

pub fn g() {
    println!("nested.rs::g");
    nested1::nested2::f(); // $ item=I4
} // I7
