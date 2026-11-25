#[path = "including/source.rs"]
mod source;

fn main() {
    source::direct::sibling::sibling_fn(); // $ item=sibling_fn
    source::direct::directory::directory_fn(); // $ item=directory_fn
    source::direct::inline::child::inline_fn(); // $ item=inline_fn
    source::direct::nested_child::nested_fn(); // $ item=nested_fn
    source::raw::sibling::sibling_fn(); // $ item=sibling_fn
    source::wrapped::sibling::sibling_fn(); // $ item=sibling_fn
    source::local::local_child::local_fn(); // $ item=local_fn
}
