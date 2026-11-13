fn main() {
    let out = std::path::PathBuf::from(std::env::var_os("OUT_DIR").unwrap());
    std::fs::write(
        out.join("generated.rs"),
        r#"
extern crate self as generated_self;

pub fn generated_function() -> i32 {
    crate::root_function()
}

pub fn generated_alias() -> i32 {
    generated_self::root_function()
}

pub mod inline {
    #[macro_export]
    macro_rules! generated_export {
        () => { $crate::root_function(); };
    }
}
"#,
    )
    .unwrap();
}
