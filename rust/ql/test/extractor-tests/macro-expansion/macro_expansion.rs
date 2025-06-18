use proc_macro::{repeat, add_one, erase};

#[add_one]
pub fn foo() {
    _ = concat!("Hello ", "world!");

    #[repeat(2)]
    fn inner() {}

    inner_0();
    inner_1();
}

#[repeat(2)]
#[add_one]
pub fn bar() {}

#[erase]
pub fn baz() {}


macro_rules! hello {
    () => {
        println!("hello!");
    };
}

pub struct S;

impl S {
    #[repeat(3)]
    pub fn bzz() {
        hello!();
    }
}

macro_rules! def_x {
    () => {
        pub fn x() {}
    };
}

impl S {
    def_x!();  // this doesn't expand since 0.0.274
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

include!("included/included.rs");

#[doc = include_str!("some.txt")]  // this doesn't expand since 0.0.274
fn documented() {}

macro_rules! my_int {
    () => { i32 };
}

fn answer() -> my_int!() {  // this didn't expand in 0.0.274..0.0.287
    let a: my_int!() = 42;  // this is fine
    a as my_int!() // this is fine too
}


type MyInt = my_int!();  // this didn't expand in 0.0.274..0.0.287

struct MyStruct {
    field: my_int!(),  // this didn't expand in 0.0.274..0.0.287
}
