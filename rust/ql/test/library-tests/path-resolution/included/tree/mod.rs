pub mod included_module;

include!("nested/mod.rs");

pub mod inline_export {
    #[macro_export]
    macro_rules! included_export {
        () => {};
    }
}
