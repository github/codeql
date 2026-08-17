// Regression test: `#[cfg(...)]`-disabled items produced by a macro expansion must be
// excluded from extraction, just like disabled items written directly in a source file.
// `any()` is always false and `all()` is always true, so this does not depend on crate features.

macro_rules! make_cfg_items {
    () => {
        #[cfg(any())] // always false: must be excluded
        pub fn from_macro_disabled() {}

        #[cfg(all())] // always true: must be kept
        pub fn from_macro_enabled() {}
    };
}

make_cfg_items!();

// Baseline: the same predicates on items written directly in the file (not via a macro).
#[cfg(any())] // always false: must be excluded
pub fn direct_disabled() {}

#[cfg(all())] // always true: must be kept
pub fn direct_enabled() {}
