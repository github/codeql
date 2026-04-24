mod regression1 {

    pub struct S<T>(T);

    pub enum E {
        V { vec: Vec<E> },
    }

    impl<T> From<S<T>> for Option<T> {
        fn from(s: S<T>) -> Self {
            Some(s.0) // $ fieldof=S
        }
    }

    pub fn f() -> E {
        let mut vec_e = Vec::new(); // $ target=new
        let mut opt_e = None;

        let e = E::V { vec: Vec::new() }; // $ target=new

        if let Some(e) = opt_e {
            vec_e.push(e); // $ target=push
        }
        opt_e = e.into(); // $ target=into

        #[rustfmt::skip]
        let _ = if let Some(last) = vec_e.pop() // $ target=pop
        {
            opt_e = last.into(); // $ target=into
        };

        opt_e.unwrap() // $ target=unwrap
    }
}

mod regression2 {
    use std::ops::Sub;

    #[derive(Copy, Clone)]
    struct S1;
    #[derive(Copy, Clone)]
    struct S2;

    impl Sub for S1 {
        type Output = Self;

        // S1SubS1
        fn sub(self, _rhs: Self) -> Self::Output {
            S1
        }
    }

    impl Sub<S2> for S1 {
        type Output = S2;

        // S1SubS2
        fn sub(self, _rhs: S2) -> Self::Output {
            S2
        }
    }

    impl Sub<&S2> for S1 {
        type Output = <S1 as Sub<S2>>::Output;

        // S1SubRefS2
        fn sub(self, other: &S2) -> <S1 as Sub<S2>>::Output {
            Sub::sub(self, *other) // $ target=S1SubS2 target=deref
        }
    }

    fn foo() {
        let s1 = S1;
        let s2 = S2;
        let x = s1 - &s2; // $ target=S1SubRefS2 type=x:S2
    }
}

mod regression3 {
    trait SomeTrait {}

    trait MyFrom<T> {
        fn my_from(value: T) -> Self;
    }

    impl<T> MyFrom<T> for T {
        fn my_from(s: T) -> Self {
            s
        }
    }

    impl<T> MyFrom<T> for Option<T> {
        fn my_from(val: T) -> Option<T> {
            Some(val)
        }
    }

    pub struct S<Ts>(Ts);

    pub fn f<T1, T2>(x: T2) -> T2
    where
        T2: SomeTrait + MyFrom<Option<T1>>,
        Option<T1>: MyFrom<T2>,
    {
        let y = MyFrom::my_from(x); // $ target=my_from
        let z = MyFrom::my_from(y); // $ target=my_from
        z
    }
}

mod regression4 {
    trait MyTrait {
        // MyTrait::m
        fn m(self);
    }

    impl<T> MyTrait for &T {
        // RefAsMyTrait::m
        fn m(self) {}
    }

    struct S<T>(T);

    impl<T> S<T> {
        fn call_m(self)
        where
            T: MyTrait,
        {
            let S(s) = self;
            s.m(); // $ target=MyTrait::m
        }
    }
}
