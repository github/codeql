use crate::regular::*;

fn usage() {
    let s = Struct {};
    s.f();
    s.g();
    s.h();
    free();
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

fn use_trait() {
    ().f();
    (0, "").f();
    vec![0, 1, 2].as_slice().f();
    ["", ""].f();
    ["", "", ""].f();
}
