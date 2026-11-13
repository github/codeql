include!(concat!(env!("OUT_DIR"), "/generated.rs"));

fn root_function() -> i32 {
    42
}

fn main() {
    generated_function();
    crate::generated_export!();
}
