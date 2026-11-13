fn included() {
    _ = concat!("Hello", " ", "world!");  // this doesn't expand (in included.rs) since 0.0.274
}

#[derive(Debug)]
struct IncludedDerived {
    value: usize,
}
