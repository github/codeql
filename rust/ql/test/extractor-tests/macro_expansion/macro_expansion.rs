#[ctor::ctor]
fn foo() {}

#[cfg(any(linux, not(linux)))]
fn bar() {}

#[cfg(all(linux, not(linux)))]
fn baz() {}
