
fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
}

// Flow through `clone` methods

fn option_clone() {
    let a = Some(source(88));
    sink(a.unwrap()); // $ hasValueFlow=88
    let b = a.clone();
    sink(b.unwrap()); // $ hasValueFlow=88
}

fn result_clone() {
    let a: Result<i64, i64> = Ok(source(37));
    sink(a.unwrap()); // $ hasValueFlow=37
    let b = a.clone();
    sink(b.unwrap()); // $ hasValueFlow=37
}

fn i64_clone() {
    let a = source(12);
    sink(a); // $ hasValueFlow=12
    let b = a.clone();
    sink(b); // $ hasValueFlow=12
}

mod my_clone {
    use super::{source, sink};

    #[derive(Clone)]
    struct Wrapper {
        n: i64
    }

    pub fn wrapper_clone() {
        let w = Wrapper { n: source(73) };
        match w {
            Wrapper { n: n } => sink(n) // $ hasValueFlow=73
        }
        let u = w.clone();
        match u {
            Wrapper { n: n } => sink(n) // $ hasValueFlow=73
        }
    }
}

mod flow_through_option {
    use super::{source, sink};
    // Test the auto generated flow summaries for `Option`

    fn zip_flow() {
        let a = Some(2);
        let b = Some(source(38));
        let z = a.zip(b);
        match z {
            Some((n, m)) => {
                sink(n);
                sink(m); // $ hasValueFlow=38
            },
            None => ()
        }
    }

    fn higher_order_flow() {
        let a = Some(0);
        let b = a.map_or(3, |n| n + source(63));
        sink(b); // $ hasTaintFlow=63
    }
}

fn main() {
    option_clone();
    result_clone();
    i64_clone();
    my_clone::wrapper_clone();
}
