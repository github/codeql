pub mod nested3 {
    pub mod nested4 {
        pub fn f() {
            println!("nested2.rs::nested3::nested4::f"); // $ item=println
        } // I12

        pub fn g() {
            println!("nested2.rs::nested3::nested4::g"); // $ item=println
        } // I13
    } // I11
} // I10

pub mod nested5 {
    pub mod nested6 {
        pub fn f() {
            println!("nested2.rs::nested5::nested6::f"); // $ item=println
        } // I116
    } // I115
} // I114

pub mod nested7 {
    pub mod nested8 {
        pub fn f() {
            println!("nested2.rs::nested7::nested8::f"); // $ item=println
        } // I119
    } // I118
} // I117
