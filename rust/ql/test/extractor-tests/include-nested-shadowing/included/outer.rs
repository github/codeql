macro_rules! nested_shadow {
    () => { struct FromOuter; };
}
include!("a.rs");
include!("b.rs");
include!("middle.rs");
nested_shadow!();
