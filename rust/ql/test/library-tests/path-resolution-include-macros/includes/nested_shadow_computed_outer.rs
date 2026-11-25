macro_rules! include {
    ($path:expr) => {
        pub mod nested_shadow_computed_child;
    };
}

include!(concat!("unused/", "nested.rs"));
