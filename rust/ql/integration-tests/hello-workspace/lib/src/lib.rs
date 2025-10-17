#[macro_use]
mod macros {
    #[macro_export]
    macro_rules! my_macro1 {
        () => {
            println!("my_macro!");
        };
    }
    #[macro_export]
    macro_rules! my_macro2 {
        () => {
            $crate::my_macro1!();
        };
    }
}

pub mod a_module;
