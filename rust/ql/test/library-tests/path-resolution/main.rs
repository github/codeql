mod my; // I1

use my::*; // $ item=I1

use my::nested::nested1::nested2::*; // $ item=I3

mod my2; // I14

use my2::*; // $ item=I14

use my2::nested2::nested3::nested4::{f, g}; // $ item=I11 item=I12 item=I13

mod m1 {
    fn f() {
        println!("main.rs::m1::f");
    } // I16

    pub mod m2 {
        fn f() {
            println!("main.rs::m1::m2::f");
        } // I18

        pub fn g() {
            println!("main.rs::m1::m2::g");
            f(); // $ item=I18
            super::f(); // $ item=I16
        } // I19

        pub mod m3 {
            use super::f; // $ item=I18
            pub fn h() {
                println!("main.rs::m1::m2::m3::h");
                f(); // $ item=I18
            } // I21
        } // I20
    } // I17
} // I15

mod m4 {
    use super::m1::m2::g; // $ item=I19

    pub fn i() {
        println!("main.rs::m4::i");
        g(); // $ item=I19
    } // I23
} // I22

struct Foo {} // I24

fn h() {
    println!("main.rs::h");

    struct Foo {} // I26

    fn f() {
        use m1::m2::g; // $ item=I19
        g(); // $ item=I19

        struct Foo {} // I28
        println!("main.rs::h::f");
        let _ = Foo {}; // $ item=I28
    } // I27

    let _ = Foo {}; // $ item=I26

    f(); // $ item=I27

    self::i(); // $ item=I29
} // I25

fn i() {
    println!("main.rs::i");

    let _ = Foo {}; // $ item=I24

    {
        struct Foo {
            x: i32,
        } // I30

        let _ = Foo { x: 0 }; // $ item=I30
    }
} // I29

use my2::nested2 as my2_nested2_alias; // $ item=I8

use my2_nested2_alias::nested3::{nested4::f as f_alias, nested4::g as g_alias, nested4::*}; // $ item=I10 item=I12 item=I13 item=I11

macro_rules! fn_in_macro {
    ($e:expr) => {
        fn f_defined_in_macro() {
            $e
        }
    };
}

fn j() {
    println!("main.rs::j");
    fn_in_macro!(println!("main.rs::j::f"));
    f_defined_in_macro(); // $ item=f_defined_in_macro
} // I31

mod m5 {
    pub fn f() {
        println!("main.rs::m5::f");
    } // I33
} // I32

mod m6 {
    fn f() {
        println!("main.rs::m6::f");
    } // I35

    pub fn g() {
        println!("main.rs::m6::g");
        // this import shadows the definition `I35`, which we don't currently handle
        use super::m5::*; // $ item=I32
        f(); // $ item=I33 $ SPURIOUS: item=I35
    } // I36
} // I34

mod m7 {
    pub enum MyEnum {
        A(i32),       // I42
        B { x: i32 }, // I43
        C,            // I44
    } // I41

    #[rustfmt::skip]
    pub fn f() -> MyEnum // $ item=I41 
    {
        println!("main.rs::m7::f");
        let _ = MyEnum::A(0); // $ item=I42
        let _ = MyEnum::B { x: 0 }; // $ item=I43
        MyEnum::C // $ item=I44
    } // I45
} // I40

mod m8 {
    trait MyTrait {
        fn f(&self); // I48

        fn g(&self) {
            println!("main.rs::m8::MyTrait::g");
            f(); // $ item=I51
            Self::f(self); // $ item=I48
        } // I49
    } // I47

    struct MyStruct {} // I50

    fn f() {
        println!("main.rs::m8::f");
    } // I51

    #[rustfmt::skip]
    impl MyTrait for MyStruct { // $ item=I47 item=I50
        fn f(&self) {
            println!("main.rs::m8::<MyStruct as MyTrait>::f");
            f(); // $ item=I51
            Self::g(self); // $ item=I54
        } // I53

        fn g(&self) {
            println!("main.rs::m8::<MyStruct as MyTrait>::g");
        } // I54
    } // I52

    #[rustfmt::skip]
    pub fn g() {
        let x = MyStruct {}; // $ item=I50
        MyTrait::f(&x); // $ item=I48
        <MyStruct as // $ item=I50
         MyTrait // $ MISSING: item=I47
        > // $ MISSING: item=52
        ::f(&x); // $ MISSING: item=I53
        let x = MyStruct {}; // $ item=I50
        x.f(); // $ MISSING: item=I53
        let x = MyStruct {}; // $ item=I50
        x.g(); // $ MISSING: item=I54
    } // I55
} // I46

mod m9 {
    pub struct MyStruct {} // I56

    #[rustfmt::skip]
    pub fn f() -> self::MyStruct { // $ item=I56
        println!("main.rs::m9::f");
        self::MyStruct {} // $ item=I56
    } // I57
}

fn main() {
    my::nested::nested1::nested2::f(); // $ item=I4
    my::f(); // $ item=I38
    nested2::nested3::nested4::f(); // $ item=I12
    f(); // $ item=I12
    g(); // $ item=I13
    crate::h(); // $ item=I25
    m1::m2::g(); // $ item=I19
    m1::m2::m3::h(); // $ item=I21
    m4::i(); // $ item=I23
    h(); // $ item=I25
    f_alias(); // $ item=I12
    g_alias(); // $ item=I13
    j(); // $ item=I31
    m6::g(); // $ item=I36
    m7::f(); // $ item=I45
    m8::g(); // $ item=I55
    m9::f(); // $ item=I57
}
