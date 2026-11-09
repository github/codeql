#[cfg(all(feature = "a", feature = "b"))]
pub fn a() {}

#[cfg(all(feature = "a", not(feature = "b")))]
mod only_a;

#[cfg(all(feature = "a", not(feature = "b")))]
pub use only_a::a;

#[cfg(feature = "b")]
pub fn b() {}

#[cfg(feature = "b")]
#[macro_export]
macro_rules! invoke {
    () => {
        $crate::b()
    };
}

#[cfg(not(feature = "b"))]
#[macro_export]
macro_rules! invoke {
    () => {
        $crate::a()
    };
}
