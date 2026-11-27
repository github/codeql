pub mod included_module;

include!("nested/mod.rs");
declare_included_child!();

#[cfg(any())]
pub mod disabled_child;

pub mod inline_export {
    #[macro_export]
    macro_rules! included_export {
        () => {};
    }

    #[cfg(any())]
    #[macro_export]
    macro_rules! disabled_export {
        () => {};
    }
}
