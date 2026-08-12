pub fn may_invoke_callback1<F: Fn(i64)>(f: F) {}

pub fn may_invoke_callback2<F: FnOnce(i64)>(f: F) {}

pub fn may_invoke_callback3(f: impl Fn(i64)) {}

pub fn may_invoke_callback4<T>(f: T)
where
    T: for<'a> FnOnce(&'a mut i64),
{
}
