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

trait GenericTrait<T> {
    fn generic_method(&self, t: T);
}

struct GenericStruct<T, U> {
    pub t: T,
    pub u: U,
}

struct GenericTupleStruct<T, U>(T, U);


enum GenericEnum<T, U> {
    T(T),
    U(U),
}

impl<T> GenericTrait<T> for GenericStruct<i32, T> {
    fn generic_method(&self, t: T) {}
}

impl GenericTrait<i32> for GenericStruct<&str, i32> {
    fn generic_method(&self, t: i32) {}
}

impl<T> GenericTrait<T> for GenericTupleStruct<i32, T> {
    fn generic_method(&self, t: T) {}
}

impl GenericTrait<i32> for GenericTupleStruct<&str, i32> {
    fn generic_method(&self, t: i32) {}
}

impl<T> GenericTrait<T> for GenericEnum<i32, T> {
    fn generic_method(&self, t: T) {}
}

impl GenericTrait<i32> for GenericEnum<&str, i32> {
    fn generic_method(&self, t: i32) {}
}

fn generic_usage() {
    let x = GenericStruct { t: 0, u: "" };
    x.generic_method("hi");
    let x = GenericStruct { t: "hello", u: 42 };
    x.generic_method(0);
    let x = GenericTupleStruct(0, "");
    x.generic_method("hi");
    let x = GenericTupleStruct("hello", 42);
    x.generic_method(0);
    let x = GenericEnum::<_, &str>::T(0);
    x.generic_method("hey");
    let x = GenericEnum::<&str, _>::U(0);
    x.generic_method(1);
}

impl Trait for () {
    fn f(&self) {}
}

impl Trait for (i32, &str) {
    fn f(&self) {}
}

impl Trait for [i32] {
    fn f(&self) {}
}

impl Trait for [&str; 2] {
    fn f(&self) {}
}

impl Trait for [&str; 3] {
    fn f(&self) {}
}

fn use_trait() {
    ().f();
    (0, "").f();
    vec![0, 1, 2].as_slice().f();
    ["", ""].f();
    ["", "", ""].f();
}
