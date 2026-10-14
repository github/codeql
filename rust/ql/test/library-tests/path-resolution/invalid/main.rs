// The code in this file is not valid Rust code

struct A; // A1
struct A; // A2

fn f(x: A) {} // $ item=A2 (the latter occurence takes precedence)

/// Test `m::{self}` where `m` is a struct. Per the Rust specification `m` must
/// resolve to a module, trait, or enum:
/// https://doc.rust-lang.org/reference/items/use-declarations.html#r-items.use.self.module
mod self_import_from_struct {
    struct MyStruct; // Struct

    #[rustfmt::skip]
    use self::MyStruct::{ // $ item=Struct
        self // $ SPURIOUS: item=self_import_from_struct
    };
}
