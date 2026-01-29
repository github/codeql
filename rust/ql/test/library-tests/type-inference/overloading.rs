mod method_call_trait_path_disambig {
    trait FirstTrait {
        // FirstTrait::method
        fn method(&self) -> bool {
            true
        }
    }
    trait SecondTrait {
        // SecondTrait::method
        fn method(&self) -> i64 {
            1
        }
    }
    struct S;
    impl FirstTrait for S {}
    impl SecondTrait for S {}

    fn _test() {
        let s = S;

        let _b1 = FirstTrait::method(&s); // $ type=_b1:bool target=FirstTrait::method
        let _b2 = <S as FirstTrait>::method(&s); // $ type=_b2:bool target=FirstTrait::method

        let _n1 = SecondTrait::method(&s); // $ type=_n1:i64 target=SecondTrait::method
        let _n2 = <S as SecondTrait>::method(&s); // $ type=_n2:i64 target=SecondTrait::method
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
