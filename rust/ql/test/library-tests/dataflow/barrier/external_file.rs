pub trait MyBarrierTrait2 {
    fn sanitize2(s: &str);
}

impl<T> MyBarrierTrait2 for T {
    // inherits model from the trait function
    fn sanitize2(s: &str) {}
}
