mod method_call_trait_path_disambig {
    trait FirstTrait {
        // FirstTrait::method
        fn method(&self) -> bool {
            true
        }

        fn method2(&self) -> bool;

        fn function() -> bool;
    }
    trait SecondTrait {
        // SecondTrait::method
        fn method(&self) -> i64 {
            1
        }

        fn method2(&self) -> i64;
    }
    #[derive(Default)]
    struct S;
    impl FirstTrait for S {
        // S_as_FirstTrait::method2
        fn method2(&self) -> bool {
            true
        }

        // S::function
        fn function() -> bool {
            true
        }
    }
    impl SecondTrait for S {
        // S_as_SecondTrait::method2
        fn method2(&self) -> i64 {
            1
        }
    }

    struct S2;
    impl FirstTrait for S2 {
        // S2::method2
        fn method2(&self) -> bool {
            false
        }

        // S2::function
        fn function() -> bool {
            false
        }
    }

    fn _test() {
        let s = S;

        let _b1 = FirstTrait::method(&s); // $ type=_b1:bool target=FirstTrait::method
        let _b2 = <S as FirstTrait>::method(&s); // $ type=_b2:bool target=FirstTrait::method
        let _b3 = <S as FirstTrait>::method(&Default::default()); // $ type=_b3:bool target=FirstTrait::method target=default
        let _b4 = <S as FirstTrait>::method2(&s); // $ type=_b4:bool target=S_as_FirstTrait::method2
        let _b5 = <S as FirstTrait>::method2(&Default::default()); // $ type=_b5:bool target=S_as_FirstTrait::method2 target=default

        let _n1 = SecondTrait::method(&s); // $ type=_n1:i64 target=SecondTrait::method
        let _n2 = <S as SecondTrait>::method(&s); // $ type=_n2:i64 target=SecondTrait::method
        let _n3 = <S as SecondTrait>::method(&Default::default()); // $ type=_n3:i64 target=SecondTrait::method target=default
        let _n4 = <S as SecondTrait>::method2(&s); // $ type=_n4:i64 target=S_as_SecondTrait::method2
        let _n5 = <S as SecondTrait>::method2(&Default::default()); // $ type=_n5:i64 target=S_as_SecondTrait::method2 target=default

        <S as FirstTrait>::function(); // $ target=S::function
        <S2 as FirstTrait>::function(); // $ target=S2::function
    }
}

pub mod impl_overlap {
    #[derive(Debug, Clone, Copy)]
    struct S1;

    trait OverlappingTrait {
        fn common_method(self) -> S1;

        fn common_method_2(self, s1: S1) -> S1;
    }

    impl OverlappingTrait for S1 {
        // <S1_as_OverlappingTrait>::common_method
        fn common_method(self) -> S1 {
            S1
        }

        // <S1_as_OverlappingTrait>::common_method_2
        fn common_method_2(self, s1: S1) -> S1 {
            S1
        }
    }

    impl S1 {
        // S1::common_method
        fn common_method(self) -> S1 {
            self
        }

        // S1::common_method_2
        fn common_method_2(self) -> S1 {
            self
        }
    }

    struct S2<T2>(T2);

    impl S2<i32> {
        // S2<i32>::common_method
        fn common_method(self) -> S1 {
            S1
        }

        // S2<i32>::common_method
        fn common_method_2(self) -> S1 {
            S1
        }
    }

    impl OverlappingTrait for S2<i32> {
        // <S2<i32>_as_OverlappingTrait>::common_method
        fn common_method(self) -> S1 {
            S1
        }

        // <S2<i32>_as_OverlappingTrait>::common_method_2
        fn common_method_2(self, s1: S1) -> S1 {
            S1
        }
    }

    impl OverlappingTrait for S2<S1> {
        // <S2<S1>_as_OverlappingTrait>::common_method
        fn common_method(self) -> S1 {
            S1
        }

        // <S2<S1>_as_OverlappingTrait>::common_method_2
        fn common_method_2(self, s1: S1) -> S1 {
            S1
        }
    }

    #[derive(Debug)]
    struct S3<T3>(T3);

    trait OverlappingTrait2<T> {
        fn m(&self, x: &T) -> &Self;
    }

    impl<T> OverlappingTrait2<T> for S3<T> {
        // <S3<T>_as_OverlappingTrait2<T>>::m
        fn m(&self, x: &T) -> &Self {
            self
        }
    }

    impl<T> S3<T> {
        // S3<T>::m
        fn m(&self, x: T) -> &Self {
            self
        }
    }

    trait MyTrait1 {
        // MyTrait1::m
        fn m(&self) {}
    }

    trait MyTrait2: MyTrait1 {}

    #[derive(Debug)]
    struct S4;

    impl MyTrait1 for S4 {
        // <S4_as_MyTrait1>::m
        fn m(&self) {}
    }

    impl MyTrait2 for S4 {}

    #[derive(Debug)]
    struct S5<T5>(T5);

    impl MyTrait1 for S5<i32> {
        // <S5<i32>_as_MyTrait1>::m
        fn m(&self) {}
    }

    impl MyTrait2 for S5<i32> {}

    impl MyTrait1 for S5<bool> {}

    impl MyTrait2 for S5<bool> {}

    pub fn f() {
        let x = S1;
        println!("{:?}", x.common_method()); // $ target=S1::common_method
        println!("{:?}", S1::common_method(x)); // $ target=S1::common_method
        println!("{:?}", x.common_method_2()); // $ target=S1::common_method_2
        println!("{:?}", S1::common_method_2(x)); // $ target=S1::common_method_2

        let y = S2(S1);
        println!("{:?}", y.common_method()); // $ target=<S2<S1>_as_OverlappingTrait>::common_method
        println!("{:?}", S2::<S1>::common_method(S2(S1))); // $ target=<S2<S1>_as_OverlappingTrait>::common_method

        let z = S2(0);
        println!("{:?}", z.common_method()); // $ target=S2<i32>::common_method
        println!("{:?}", S2::common_method(S2(0))); // $ target=S2<i32>::common_method
        println!("{:?}", S2::<i32>::common_method(S2(0))); // $ target=S2<i32>::common_method

        let w = S3(S1);
        println!("{:?}", w.m(x)); // $ target=S3<T>::m
        println!("{:?}", S3::m(&w, x)); // $ target=S3<T>::m

        S4.m(); // $ target=<S4_as_MyTrait1>::m
        S4::m(&S4); // $ target=<S4_as_MyTrait1>::m
        S5(0i32).m(); // $ target=<S5<i32>_as_MyTrait1>::m
        S5::m(&S5(0i32)); // $ target=<S5<i32>_as_MyTrait1>::m
        S5(true).m(); // $ target=MyTrait1::m
        S5::m(&S5(true)); // $ target=MyTrait1::m
    }
}

mod impl_overlap2 {
    trait Trait1<T1> {
        fn f(self, x: T1) -> T1;
    }

    impl Trait1<i32> for i32 {
        // f1
        fn f(self, x: i32) -> i32 {
            0
        }
    }

    impl Trait1<i64> for i32 {
        // f2
        fn f(self, x: i64) -> i64 {
            0
        }
    }

    trait Trait2<T1, T2> {
        fn g(self, x: T1) -> T2;
    }

    impl Trait2<i32, i32> for i32 {
        // g3
        fn g(self, x: i32) -> i32 {
            0
        }
    }

    impl Trait2<i32, i64> for i32 {
        // g4
        fn g(self, x: i32) -> i64 {
            0
        }
    }

    fn f() {
        let x = 0;
        let y = x.f(0i32); // $ target=f1
        let z: i32 = x.f(Default::default()); // $ target=f1 target=default
        let z = x.f(0i64); // $ target=f2
        let z: i64 = x.f(Default::default()); // $ target=f2 target=default
        let z: i64 = x.g(0i32); // $ target=g4
    }
}

mod impl_overlap3 {
    trait Trait {
        type Assoc;

        fn Assoc() -> Self::Assoc;
    }

    struct S<T>(T);

    impl Trait for S<i32> {
        type Assoc = i32;

        // S3i32AssocFunc
        fn Assoc() -> Self::Assoc {
            0
        }
    }

    impl Trait for S<bool> {
        type Assoc = bool;

        // S3boolAssocFunc
        fn Assoc() -> Self::Assoc {
            true
        }
    }

    impl S<i32> {
        // S3i32f
        fn f(x: i32) -> i32 {
            0
        }
    }

    impl S<bool> {
        // S3boolf
        fn f(x: bool) -> bool {
            true
        }
    }

    fn f() {
        S::<i32>::Assoc(); // $ target=S3i32AssocFunc
        S::<bool>::Assoc(); // $ target=S3boolAssocFunc

        // `S::f(true)` results in "multiple applicable items in scope", even though the argument is actually enough to disambiguate
        S::<bool>::f(true); // $ target=S3boolf
        S::<i32>::f(0); // $ target=S3i32f
    }
}

mod default_type_args {
    struct S<T = i64>(T);

    trait MyTrait {
        type AssocType;

        fn g(self) -> Self::AssocType;
    }

    impl S {
        fn f(self) -> i64 {
            self.0 // $ fieldof=S
        }

        fn g(self) -> i64 {
            self.0 // $ fieldof=S
        }
    }

    impl S<bool> {
        fn g(self) -> bool {
            self.0 // $ fieldof=S
        }
    }

    impl<T> MyTrait for S<T> {
        type AssocType = S;

        fn g(self) -> S {
            let x = S::f(S(Default::default())); // $ target=f target=default type=x:i64
            let x = Self::AssocType::f(S(Default::default())); // $ target=f target=default type=x:i64
            let x = S::<bool>::g(S(Default::default())); // $ target=g target=default type=x:bool
            let x = S::<i64>::g(S(Default::default())); // $ target=g target=default type=x:i64
            let x = Self::AssocType::g(S(Default::default())); // $ target=g target=default type=x:i64
            S(0)
        }
    }
}

mod from_default {
    #[derive(Default)]
    struct S;

    fn f() -> S {
        let x = Default::default(); // $ target=default type=x:S
        From::from(x) // $ target=from
    }

    struct S1;

    struct S2;

    impl From<S> for S1 {
        // from1
        fn from(_: S) -> Self {
            S1
        }
    }

    impl From<S2> for S1 {
        // from2
        fn from(_: S2) -> Self {
            S1
        }
    }

    impl From<S> for S2 {
        // from3
        fn from(_: S) -> Self {
            S2
        }
    }

    fn g(b: bool) -> S1 {
        let s = if b { S } else { Default::default() }; // $ target=default type=s:S
        let x = From::from(s); // $ target=from1 type=x:S1
        x
    }
}
