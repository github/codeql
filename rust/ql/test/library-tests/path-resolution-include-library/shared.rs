#[macro_export]
macro_rules! included_library_export {
    () => {};
}

pub fn helper() {}

pub fn check() {
    crate::shared::helper(); // $ item=helper
}
