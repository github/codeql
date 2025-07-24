struct S;

mod lib;

mod M1 {
    pub mod M2 {
        pub struct S;

        impl S {
            pub fn method(self) -> Self {
                S
            }
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
}
