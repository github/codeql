macro_rules! include {
    ($path:literal) => {
        pub mod nested_shadow_child;
    };
}

include!("unused_nested.rs");
