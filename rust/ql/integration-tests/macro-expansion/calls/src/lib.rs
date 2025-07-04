struct S;

macro_rules! def_x {
    () => {
        fn x() {}
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

include!("included.rs");

#[doc = include_str!("some.txt")]  // this doesn't expand since 0.0.274
fn documented() {}
