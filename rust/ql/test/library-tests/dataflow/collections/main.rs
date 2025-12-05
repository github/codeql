fn source<T>(s: T) -> T {
    s
}

fn sink(s: i64) {
    println!("{}", s);
}

mod arrays {
    use crate::*;
    use std::ops::Index;
    use std::ops::IndexMut;

    pub fn f() {
        let s = source(0);
        let arr = [s; 5];
        sink(arr[2]); // $ hasValueFlow=0
        sink(*arr.index(2)); // $ hasValueFlow=0

        let mut arr = source([1]);
        sink(arr[0]); // $ hasTaintFlow=1
        sink(*arr.index(0)); // $ hasTaintFlow=1

        let s = source(2);
        let arr = [s];
        for x in arr {
            sink(x); // $ hasValueFlow=2
        }

        let arr = source([3]);
        for x in arr {
            sink(x); // $ hasTaintFlow=3
        }

        let mut arr = [0];
        sink(arr[0]);
        arr[0] = source(4);
        sink(arr[0]); // $ hasValueFlow=4

        let mut arr = [0];
        sink(arr[0]);
        *arr.index_mut(0) = source(5);
        sink(arr[0]); // $ MISSING: hasValueFlow=5 -- needs generalized reverse flow

        let mut arr = [0];
        arr[0] += source(6);
        sink(arr[0]); // $ hasTaintFlow=6
    }
}

mod indexers {
    use crate::*;
    use std::ops::AddAssign;
    use std::ops::Index;
    use std::ops::IndexMut;

    #[derive(Debug)]
    struct S<T>(T);

    impl<T> Index<usize> for S<T> {
        type Output = S<T>; // `T` would be a better choice here, but that requires generalized reverse flow for the test to pass

        fn index(&self, index: usize) -> &Self::Output {
            self
        }
    }

    impl<T> IndexMut<usize> for S<T> {
        // `Self::Output` is not yet handled, so use `S<T>` for now
        fn index_mut(&mut self, index: usize) -> &mut S<T> {
            self
        }
    }

    impl std::ops::AddAssign for S<i64> {
        fn add_assign(&mut self, other: Self) {
            self.0 += other.0;
        }
    }

    pub fn f() {
        let s = source(0);
        let s = S(s);
        sink(s[0].0); // $ hasValueFlow=0
        sink((*s.index(0)).0); // $ hasValueFlow=0

        let mut s = S(0);
        sink(s.0);
        s[0] = S(source(1));
        sink(s.0); // $ hasValueFlow=1

        let mut s = S(0);
        sink(s.0);
        *s.index_mut(0) = S(source(2));
        sink(s.0); // $ hasValueFlow=2

        let mut s = S(0i64);
        sink(s.0);
        s[0] += S(source(3));
        sink(s.0); // $ hasTaintFlow=3

        let mut s = S(0i64);
        sink(s.0);
        *s.index_mut(0) += S(source(5));
        s[0] += S(source(5));
        sink(s.0); // $ hasTaintFlow=5

        let mut s = S(0i64);
        sink(s.0);
        (*s.index_mut(0)).add_assign(S(source(6)));
        sink(s.0); // $ hasTaintFlow=6
    }
}

fn main() {
    arrays::f();
    indexers::f();
}
