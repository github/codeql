use std::ops::*;

#[derive(Debug, Copy, Clone)]
struct S;

mod lib;

impl Neg for S {
    type Output = Self;

    fn neg(self) -> Self {
        S
    }
}

impl Add for S {
    type Output = Self;

    fn add(self, rhs: Self) -> Self {
        S
    }
}

impl Index<usize> for S {
    type Output = S;

    fn index(&self, index: usize) -> &Self::Output {
        &S
    }
}

mod M1 {
    pub mod M2 {
        pub struct S;

        impl S {
            pub fn method(self) -> Self {
                S
            }
        }
    }

    pub struct S2<T>(T);

    impl<T> S2<T> {
        pub fn new(x: T) -> Self {
            S2(x)
        }
    }
}

fn main() {
    let width = 4;
    let precision = 2;
    let value = 10;
    println!("Value {value:#width$.precision$}", value = 10.5);
    println!("Value {0:#1$.2$}", value, width, precision);
    println!("Value {} {}", value, width);
    let people = "Rustaceans";
    println!("Hello {people}!");
    println!("{1} {} {0} {}", 1, 2);
    assert_eq!(format!("Hello {:<5}!", "x"), "Hello x    !");
    let x = S;
    let s = M1::M2::S;
    s.method();
    M1::S2::<S>::new(S);
    -S;
    S + S;
    #[rustfmt::skip]
    let x = S+S;
    #[rustfmt::skip]
    let x = S
    +S;
    #[rustfmt::skip]
    let x = S
    +
    S;
    S[0];
}
