#[path = "including/source.rs"]
mod source;

mod nested_absolute {
    include!(concat!(env!("OUT_DIR"), "/nested.rs")); // $ item=include
}

mod direct_absolute {
    include!(concat!(env!("OUT_DIR"), "/absolute.rs")); // $ item=include
}

fn main() {
    source::direct::sibling::sibling_fn(); // $ item=sibling_fn
    source::direct::renamed::sibling_fn(); // $ item=sibling_fn
    source::direct::directory::directory_fn(); // $ item=directory_fn
    source::direct::inline::child::inline_fn(); // $ item=inline_fn
    source::direct::nested_child::nested_fn(); // $ item=nested_fn
    source::raw::sibling::sibling_fn(); // $ item=sibling_fn
    source::wrapped::sibling::sibling_fn(); // $ item=sibling_fn
    source::local::local_child::local_fn(); // $ item=local_fn
    nested_absolute::nested_child::nested_fn(); // $ item=nested_fn
    direct_absolute::nested_child::nested_fn(); // $ item=nested_fn
}
