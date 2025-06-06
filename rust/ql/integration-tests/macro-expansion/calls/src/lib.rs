struct S;

macro_rules! def_x {
    () => {
        fn x() {}
    };
}

impl S {
    def_x!();  // this didn't expand in 0.0.274-0.0.281
}

macro_rules! my_macro {
    ($head:expr, $($tail:tt)*) => { format!($head, $($tail)*) };
}


fn test() {
    _ = concat!("x", "y");

    _ = my_macro!(
        concat!("<", "{}", ">"),  // this doesn't expand since 0.0.274
        "hi",
    );
}

include!("included.rs");

#[doc = include_str!("some.txt")]  // this doesn't expand since 0.0.274
fn documented() {}

macro_rules! my_int {
    () => { i32 };
}

fn answer() -> my_int!() {  // this doesn't expand since 0.0.274
    let a: my_int!() = 42;  // this is fine
    a as my_int!() // this is fine too
}


type MyInt = my_int!();  // this doesn't expand since 0.0.274

struct MyStruct {
    field: my_int!(),  // this doesn't expand since 0.0.274
}
