// The code in this file is not valid Rust code, but it is used to test that
// our type inference implementation does not run into an infinite loop.

struct S<T>(T);

trait T1<T>: T2<S<T>> {
    fn foo(self) {}
}

trait T2<T>: T1<S<T>> {
    fn bar(self) {
        self.foo() // $ method=foo
    }
}
