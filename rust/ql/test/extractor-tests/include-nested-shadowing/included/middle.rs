macro_rules! nested_shadow {
    () => { struct FromMiddle; };
}
include!("inner.rs");
nested_shadow!();
