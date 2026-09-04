static GLOBAL_STATIC: i32 = 42;
static STRING_STATIC: &str = "hello";

mod my_module {
    pub static MODULE_STATIC: i32 = 200;
}

fn use_statics() {
    let x = GLOBAL_STATIC; // $ static_access=GLOBAL_STATIC

    let s = STRING_STATIC; // $ static_access=STRING_STATIC

    let z = my_module::MODULE_STATIC; // $ static_access=MODULE_STATIC

    #[rustfmt::skip]
    let _ = if GLOBAL_STATIC > 0 { // $ static_access=GLOBAL_STATIC
        println!("positive");
    };

    {
        static STRING_STATIC: &str = "inner"; // Inner1
        let _ = STRING_STATIC; // $ static_access=Inner1

        {
            static STRING_STATIC: &str = "inner2"; // Inner2
            let _ = STRING_STATIC; // $ static_access=Inner2
        }
    }
}

fn main() {
    use_statics();
}
