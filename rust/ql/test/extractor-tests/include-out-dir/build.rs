fn main() {
    let out = std::path::PathBuf::from(std::env::var_os("OUT_DIR").unwrap());
    std::fs::write(
        out.join("generated.rs"),
        r#"
extern crate self as generated_self;

pub mod child;

pub fn generated_function() -> i32 {
    crate::root_function()
}

pub fn generated_alias() -> i32 {
    generated_self::root_function()
}

pub const INCLUDED_CONST: i32 = crate::root_const();
pub static INCLUDED_STATIC: i32 = crate::root_const();

pub mod inline {
    #[macro_export]
    macro_rules! generated_export {
        () => { $crate::root_function(); };
    }
}
"#,
    )
    .unwrap();
    std::fs::write(
        out.join("child.rs"),
        r#"
pub mod grandchild;

pub fn child_function() -> i32 {
    grandchild::grandchild_function()
}
"#,
    )
    .unwrap();
    std::fs::create_dir_all(out.join("child")).unwrap();
    std::fs::write(
        out.join("child/grandchild.rs"),
        "pub fn grandchild_function() -> i32 { crate::root_function() }\n",
    )
    .unwrap();
}
