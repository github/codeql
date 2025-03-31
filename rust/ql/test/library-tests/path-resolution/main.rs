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
    impl MyStruct { // $ item=I50
        fn h(&self) {
            println!("main.rs::m8::MyStruct::h");
            f(); // $ item=I51
        } // I74
    } // I73

    #[rustfmt::skip]
    pub fn g() {
        let x = MyStruct {}; // $ item=I50
        MyTrait::f(&x); // $ item=I48
        MyStruct::f(&x); // $ item=I53
        <MyStruct as // $ item=I50
         MyTrait // $ item=I47
        > // $ MISSING: item=52
        ::f(&x); // $ MISSING: item=I53
        let x = MyStruct {}; // $ item=I50
        x.f(); // $ item=I53
        let x = MyStruct {}; // $ item=I50
        x.g(); // $ item=I54
        MyStruct::h(&x); // $ item=I74
        x.h(); // $ item=I74
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

mod m10 {
    #[rustfmt::skip]
    pub struct MyStruct<
      T // I58
    >
    {
        x: T, // $ item=I58
    } // I59

    #[rustfmt::skip]
    pub fn f<T>( // I60
        x: T // $ item=I60
    ) ->
      MyStruct<
        T // $ item=I60
      > // $ item=I59
    {
        MyStruct { x } // $ item=I59
    }
}

mod m11 {
    pub struct Foo {} // I61

    fn Foo() {} // I62

    pub fn f() {
        let _ = Foo {}; // $ item=I61
        Foo(); // $ item=I62
    } // I63

    mod f {} // I66

    pub enum Bar {
        FooBar {}, // I64
    } // I65

    use Bar::FooBar; // $ item=I64

    fn FooBar() {} // I65

    #[rustfmt::skip]
    fn g(x: Foo) { // $ item=I61
        let _ = FooBar {}; // $ item=I64
        let _ = FooBar(); // $ item=I65
    }

    struct S; // I67
    enum E {
        C, // I68
    }

    use E::C; // $ item=I68

    fn h() {
        let _ = S; // $ item=I67
        let _ = C; // $ item=I68
    }
}

mod m12 {
    #[rustfmt::skip]
    trait MyParamTrait<
      T // I69
    > {
        type AssociatedType; // I70

        fn f(
            &self,
            x: T // $ item=I69
        ) -> Self::AssociatedType; // $ item=I70
    }
}

mod m13 {
    pub fn f() {} // I71
    pub struct f {} // I72

    mod m14 {
        use crate::m13::f; // $ item=I71 item=I72

        #[rustfmt::skip]
        fn g(x: f) { // $ item=I72
            let _ = f {}; // $ item=I72
            f(); // $ item=I71
        }
    }
}

mod m15 {
    trait Trait1 {
        fn f(&self);

        fn g(&self); // I80
    } // I79

    #[rustfmt::skip]
    trait Trait2
      : Trait1 { // $ item=I79
        fn f(&self) {
            println!("m15::Trait2::f");
            Self::g(self); // $ item=I80
            self.g(); // $ item=I80
        }
    } // I82

    struct S; // I81

    #[rustfmt::skip]
    impl Trait1 // $ item=I79
      for S { // $ item=I81
        fn f(&self) {
            println!("m15::<S as Trait1>::f");
            Self::g(self); // $ item=I77
            self.g(); // $ item=I77
        } // I76

        fn g(&self) {
            println!("m15::<S as Trait1>::g");
        } // I77
    }

    #[rustfmt::skip]
    impl Trait2 // $ item=I82
      for S { // $ item=I81
        fn f(&self) {
            println!("m15::<S as Trait2>::f");
        } // I78
    }

    #[rustfmt::skip]
    pub fn f() {
        println!("m15::f");
        let x = S; // $ item=I81
        <S // $ item=I81
          as Trait1 // $ item=I79
        >::f(&x); // $ MISSING: item=I76
        <S // $ item=I81
          as Trait2 // $ item=I82
        >::f(&x); // $ MISSING: item=I78
        S::g(&x); // $ item=I77
        x.g(); // $ item=I77
    } // I75
}

mod m16 {
    #[rustfmt::skip]
    trait Trait1<
      T // I84
    > {
        fn f(&self) -> T; // $ item=I84

        fn g(&self) -> T // $ item=I84
        ; // I85

        fn h(&self) -> T { // $ item=I84
            Self::g(&self); // $ item=I85
            self.g() // $ item=I85
        } // I96

        const c: T // $ item=I84
        ; // I94
    } // I86

    #[rustfmt::skip]
    trait Trait2<
      T // I87
    > // I88
      : Trait1<
          T // $ item=I87
        > { // $ item=I86
        fn f(&self) -> T { // $ item=I87
            println!("m16::Trait2::f");
            Self::g(self); // $ item=I85
            self.g(); // $ item=I85
            Self::c // $ item=I94
        }
    } // I89

    struct S; // I90

    #[rustfmt::skip]
    impl Trait1<
      S // $ item=I90
    > // $ item=I86
      for S { // $ item=I90
        fn f(&self) -> S { // $ item=I90
            println!("m16::<S as Trait1<S>>::f");
            Self::g(self); // $ item=I92
            self.g() // $ item=I92
        } // I91

        fn g(&self) -> S { // $ item=I90
            println!("m16::<S as Trait1<S>>::g");
            Self::c // $ item=I95
        } // I92

        const c: S = S // $ item=I90
        ; // I95
    }

    #[rustfmt::skip]
    impl Trait2<
      S // $ item=I90
    > // $ item=I89
      for S { // $ item=I90
        fn f(&self) -> S { // $ item=I90
            println!("m16::<S as Trait2<S>>::f");
            Self::c // $ MISSING: item=I95
        } // I93
    }

    #[rustfmt::skip]
    pub fn f() {
        println!("m16::f");
        let x = S; // $ item=I90
        <S // $ item=I90
          as Trait1<
            S // $ item=I90
          > // $ item=I86
        >::f(&x); // $ MISSING: item=I91
        <S // $ item=I90
          as Trait2<
            S // $ item=I90
          > // $ item=I89
        >::f(&x); // $ MISSING: item=I93
        S::g(&x); // $ item=I92
        x.g(); // $ item=I92
        S::h(&x); // $ item=I96
        x.h(); // $ item=I96
        S::c; // $ item=I95
        <S // $ item=I90
          as Trait1<
            S // $ item=I90
          > // $ item=I86
        >::c; // $ MISSING: item=I95
    } // I83
}

mod m17 {
    trait MyTrait {
        fn f(&self); // I1
    } // I2

    struct S; // I3

    #[rustfmt::skip]
    impl MyTrait // $ item=I2
    for S { // $ item=I3
        fn f(&self) {
            println!("M17::MyTrait::f");
        } // I4
    }

    #[rustfmt::skip]
    fn g<T: // I5
      MyTrait // $ item=I2
    >(x: T) { // $ item=I5
        x.f(); // $ item=I1
        T::f(&x); // $ item=I1
        MyTrait::f(&x); // $ item=I1
    } // I6

    #[rustfmt::skip]
    pub fn f() {
        g( // $ item=I6
          S // $ item=I3
        );
    } // I99
}

mod m18 {
    fn f() {
        println!("m18::f");
    } // I101

    pub mod m19 {
        fn f() {
            println!("m18::m19::f");
        } // I102

        pub mod m20 {
            pub fn g() {
                println!("m18::m19::m20::g");
                super::f(); // $ item=I102
                super::super::f(); // $ item=I101
            } // I103
        }
    }
}

mod m21 {
    mod m22 {
        pub enum MyEnum {
            A, // I104
        } // I105

        pub struct MyStruct; // I106
    } // I107

    mod m33 {
        #[rustfmt::skip]
        use super::m22::MyEnum::{ // $ item=I105
            self // $ MISSING: item=I105 $ SPURIOUS: item=I107
        };

        #[rustfmt::skip]
        use super::m22::MyStruct::{ // $ item=I106
            self // $ MISSING: item=I106 $ SPURIOUS: item=I107
        };

        fn f() {
            let _ = MyEnum::A; // $ MISSING: item=I104
            let _ = MyStruct {}; // $ MISSING: item=I106
        }
    }
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
    m11::f(); // $ item=I63
    m15::f(); // $ item=I75
    m16::f(); // $ item=I83
    m17::f(); // $ item=I99
    nested6::f(); // $ item=I116
    nested8::f(); // $ item=I119
    my3::f(); // $ item=I200
    nested_f(); // $ item=I201
    m18::m19::m20::g(); // $ item=I103
}
