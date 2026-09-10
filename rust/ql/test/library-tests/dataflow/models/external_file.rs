pub fn generated_source(i: i64) -> i64 {
    0
}

pub fn neutral_generated_source(i: i64) -> i64 {
    0
}

pub fn neutral_manual_source(i: i64) -> i64 {
    0
}

pub fn generated_sink(i: i64) {}

pub fn neutral_generated_sink(i: i64) {}

pub fn neutral_manual_sink(i: i64) {}

pub fn generated_summary(i: i64) -> i64 {
    0
}

pub fn neutral_generated_summary(i: i64) -> i64 {
    0
}

pub fn neutral_manual_summary(i: i64) -> i64 {
    0
}

pub trait MyTrait2 {
    fn flow_through2(i: i64) -> i64;
}

impl<T> MyTrait2 for T {
    // inherits model from the trait function
    fn flow_through2(i: i64) -> i64 {
        0
    }
}

pub trait MySourceTrait2 {
    fn produce2(i: i64) -> i64;
}

impl<T> MySourceTrait2 for T {
    // inherits model from the trait function
    fn produce2(i: i64) -> i64 {
        0
    }
}

pub trait MySinkTrait2 {
    fn consume2(i: i64);
}

impl<T> MySinkTrait2 for T {
    // inherits model from the trait function
    fn consume2(i: i64) {}
}
