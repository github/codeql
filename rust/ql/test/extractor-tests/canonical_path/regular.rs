#[derive(Eq, PartialEq)]
pub struct Struct;

pub trait Trait {
    fn f(&self);
}

impl Trait for Struct {
    fn f(&self) {}
}

impl Struct {
    pub fn g(&self) {}
}

pub trait TraitWithBlanketImpl {
    fn h(&self);
}

impl<T: Eq> TraitWithBlanketImpl for T {
    fn h(&self) {}
}

pub fn free() {}

pub enum MyEnum {
    Variant1,
    Variant2(usize),
    Variant3 { x: usize },
}

pub trait GenericTrait<T> {
    fn generic_method(&self, t: T);
}

pub struct GenericStruct<T, U> {
    pub t: T,
    pub u: U,
}

pub struct GenericTupleStruct<T, U>(pub T, pub U);


pub enum GenericEnum<T, U> {
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

pub trait TraitWithNew {
    fn new() -> Self;
}

impl<T: Default, U: Default> TraitWithNew for GenericStruct<T, U> {
    fn new() -> Self {
        GenericStruct{t: Default::default(), u: Default::default()}
    }
}
