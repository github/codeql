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
