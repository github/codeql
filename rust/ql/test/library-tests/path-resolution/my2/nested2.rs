pub mod nested3 {
    pub mod nested4 {
        pub fn f() {
            println!("nested2.rs::nested3::nested4::f");
        } // I12

        pub fn g() {
            println!("nested2.rs::nested3::nested4::g");
        } // I13
    } // I11
} // I10
