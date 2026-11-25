macro_rules! wrapper {
    () => {
        pub mod wrapped_child;
    };
}

wrapper!();
