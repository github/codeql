macro_rules! malformed {
    () => {
        fn broken() { let = ; }
    };
}

include!("tree/generated.rs");

fn main() {}
