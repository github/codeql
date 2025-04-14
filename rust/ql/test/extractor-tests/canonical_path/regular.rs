#[derive(Eq, PartialEq)]
pub struct Struct;

pub trait Trait {
    fn f(&self);
}

impl Trait for Struct {
    fn f(&self) {}
}

impl Struct {
    fn g(&self) {}
}

trait TraitWithBlanketImpl {
    fn h(&self);
}

impl<T: Eq> TraitWithBlanketImpl for T {
    fn h(&self) {}
}

fn free() {}

fn usage() {
    let s = Struct {};
    s.f();
    s.g();
    s.h();
    free();
}

enum MyEnum {
    Variant1,
    Variant2(usize),
    Variant3 { x: usize },
}

fn enum_qualified_usage() {
    _ = Option::None::<()>;
    _ = Option::Some(0);
    _ = MyEnum::Variant1;
    _ = MyEnum::Variant2(0);
    _ = MyEnum::Variant3 { x: 1 };
}

fn enum_unqualified_usage() {
    _ = None::<()>;
    _ = Some(0);
    use MyEnum::*;
    _ = Variant1;
    _ = Variant2(0);
    _ = Variant3 { x: 1 };
}

fn enum_match(e: MyEnum) {
    match e {
        MyEnum::Variant1 => {}
        MyEnum::Variant2(_) => {}
        MyEnum::Variant3 { .. } => {}
    }
}
