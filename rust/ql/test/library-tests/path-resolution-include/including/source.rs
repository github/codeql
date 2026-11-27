pub mod direct {
    include!("../foo/bar.rs"); // $ item=include
}

pub mod local {
    include! { "local.rs" } // $ item=include
}

pub mod raw {
    include![r#"../foo/bar.rs"#,]; // $ item=include
}

macro_rules! load {
    () => {
        include!("../foo/bar.rs");
    };
}

pub mod wrapped {
    load!(); // $ item=load
}
