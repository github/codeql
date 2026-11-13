include!("lib.rs");

fn main() {
    shared::check(); // $ item=check
    crate::included_library_export!(); // $ item=included_library_export
}
