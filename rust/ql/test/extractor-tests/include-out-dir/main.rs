include!(concat!(env!("OUT_DIR"), "/generated.rs"));

fn root_function() -> i32 {
    42
}

const fn root_const() -> i32 {
    42
}

fn main() {
    generated_function();
    child::child_function();
    crate::generated_export!();
}
