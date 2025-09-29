#[macro_use]
mod macros {
    macro_rules! my_macro {
        () => {
            println!("my_macro!");
        };
    }
}

pub mod a_module;
