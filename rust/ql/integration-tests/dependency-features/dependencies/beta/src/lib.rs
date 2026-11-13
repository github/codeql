#[cfg(feature = "a")]
pub fn a() {}

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
