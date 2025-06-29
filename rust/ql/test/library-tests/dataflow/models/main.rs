fn source(i: i64) -> i64 {
    1000 + i
}

fn sink<T: std::fmt::Debug>(s: T) {
    println!("{:?}", s);
}

// has a flow model
fn identity(i: i64) -> i64 {
    0
}

fn test_identify() {
    let s = source(1);
    sink(identity(s)); // $ hasValueFlow=1
}

// has a flow model
fn coerce(_i: i64) -> i64 {
    0
}

fn test_coerce() {
    let s = source(14);
    sink(coerce(s)); // $ hasTaintFlow=14
}

enum MyPosEnum {
    A(i64),
    B(i64),
}

// has a flow model
fn get_var_pos(e: MyPosEnum) -> i64 {
    0
}

fn test_get_var_pos() {
    let s = source(2);
    let e1 = MyPosEnum::A(s);
    sink(get_var_pos(e1)); // $ hasValueFlow=2
    let e2 = MyPosEnum::B(s);
    sink(get_var_pos(e2));
}

// has a flow model
fn set_var_pos(i: i64) -> MyPosEnum {
    MyPosEnum::A(0)
}

fn test_set_var_pos() {
    let s = source(3);
    let e1 = set_var_pos(s);
    match e1 {
        MyPosEnum::A(i) => sink(i),
        MyPosEnum::B(i) => sink(i), // $ hasValueFlow=3
    }
}

enum MyFieldEnum {
    C { field_c: i64 },
    D { field_d: i64 },
}

// has a flow model
fn get_var_field(e: MyFieldEnum) -> i64 {
    0
}

fn test_get_var_field() {
    let s = source(4);
    let e1 = MyFieldEnum::C { field_c: s };
    sink(get_var_field(e1)); // $ hasValueFlow=4
    let e2 = MyFieldEnum::D { field_d: s };
    sink(get_var_field(e2));
}

// has a flow model
fn set_var_field(i: i64) -> MyFieldEnum {
    MyFieldEnum::C { field_c: 0 }
}

fn test_set_var_field() {
    let s = source(5);
    let e1 = set_var_field(s);
    match e1 {
        MyFieldEnum::C { field_c: i } => sink(i),
        MyFieldEnum::D { field_d: i } => sink(i), // $ hasValueFlow=5
    }
}

struct MyStruct {
    field1: i64,
    field2: i64,
}

// has a flow model
fn get_struct_field(s: MyStruct) -> i64 {
    0
}

fn test_get_struct_field() {
    let s = source(6);
    let my_struct = MyStruct {
        field1: s,
        field2: 0,
    };
    sink(get_struct_field(my_struct)); // $ hasValueFlow=6
    let my_struct2 = MyStruct {
        field1: 0,
        field2: s,
    };
    sink(get_struct_field(my_struct2));
}

// has a flow model
fn set_struct_field(i: i64) -> MyStruct {
    MyStruct {
        field1: 0,
        field2: 1,
    }
}

fn test_set_struct_field() {
    let s = source(7);
    let my_struct = set_struct_field(s);
    sink(my_struct.field1);
    sink(my_struct.field2); // $ hasValueFlow=7
}

// has a flow model
fn get_array_element(a: [i64; 1]) -> i64 {
    0
}

fn test_get_array_element() {
    let s = source(8);
    sink(get_array_element([s])); // $ hasValueFlow=8
}

// has a flow model
fn set_array_element(i: i64) -> [i64; 1] {
    [0]
}

fn test_set_array_element() {
    let s = source(9);
    let arr = set_array_element(s);
    sink(arr[0]); // $ hasValueFlow=9
}

// has a flow model
fn get_tuple_element(a: (i64, i64)) -> i64 {
    0
}

fn test_get_tuple_element() {
    let s = source(10);
    let t = (s, 0);
    sink(get_tuple_element(t)); // $ hasValueFlow=10
    let t = (0, s);
    sink(get_tuple_element(t));
}

// has a flow model
fn set_tuple_element(i: i64) -> (i64, i64) {
    (0, 1)
}

fn test_set_tuple_element() {
    let s = source(11);
    let t = set_tuple_element(s);
    sink(t.0);
    sink(t.1); // $ hasValueFlow=11
}

// has a flow model
pub fn apply<F>(n: i64, f: F) -> i64
where
    F: FnOnce(i64) -> i64,
{
    0
}

fn test_apply_flow_in() {
    let s = source(83);
    let f = |n| {
        sink(n); // $ hasValueFlow=83
        n + 3
    };
    apply(s, f);
}

fn test_apply_flow_out() {
    let s = source(86);
    let f = |n| if n != 0 { n } else { s };
    let t = apply(34, f);
    sink(t); // $ hasValueFlow=86
}

fn test_apply_flow_through() {
    let s = source(33);
    let f = |n| if n != 0 { n } else { 0 };
    let t = apply(s, f);
    sink(t); // $ hasValueFlow=33
}

// has a flow model with value flow from argument to returned future
async fn get_async_number(a: i64) -> i64 {
    37
}

async fn test_get_async_number() {
    let s = source(46);
    let t = get_async_number(s).await;
    sink(t); // $ hasValueFlow=46
}

impl MyFieldEnum {
    // has a source model
    fn source(&self, i: i64) -> MyFieldEnum {
        MyFieldEnum::C { field_c: 0 }
    }

    // has a sink model
    fn sink(self) {}
}

// has a source model
fn enum_source(i: i64) -> MyFieldEnum {
    MyFieldEnum::C { field_c: 0 }
}

fn test_enum_source() {
    let s = enum_source(12);
    match s {
        MyFieldEnum::C { field_c: i } => sink(i),
        MyFieldEnum::D { field_d: i } => sink(i), // $ hasValueFlow=12
    }
}

fn test_enum_method_source() {
    let e = MyFieldEnum::D { field_d: 0 };
    let s = e.source(13);
    match s {
        MyFieldEnum::C { field_c: i } => sink(i), // $ hasValueFlow=13
        MyFieldEnum::D { field_d: i } => sink(i),
    }
}

// has a sink model
fn enum_sink(e: MyFieldEnum) {}

fn test_enum_sink() {
    let s = source(14);
    enum_sink(MyFieldEnum::C { field_c: s }); // $ hasValueFlow=14
    enum_sink(MyFieldEnum::D { field_d: s });
}

fn test_enum_method_sink() {
    let s = source(15);
    let e = MyFieldEnum::D { field_d: s };
    e.sink(); // $ hasValueFlow=15
}

// has a source model
fn simple_source(i: i64) -> i64 {
    0
}

fn test_simple_source() {
    let s = simple_source(16);
    sink(s) // $ hasValueFlow=16
}

// has a sink model
fn simple_sink(i: i64) {}

fn test_simple_sink() {
    let s = source(17);
    simple_sink(s); // $ hasValueFlow=17
}

// has a source model
fn arg_source(i: i64) {}

fn test_arg_source() {
    let i = 19;
    arg_source(i);
    sink(i) // $ hasValueFlow=i
}

struct MyStruct2(i64);

impl PartialEq for MyStruct {
    fn eq(&self, other: &Self) -> bool {
        true
    }
}

impl PartialEq for MyStruct2 {
    fn eq(&self, other: &Self) -> bool {
        self.0 == other.0
    }
}

impl Eq for MyStruct {}

impl Eq for MyStruct2 {}

use std::cmp::Ordering;

impl PartialOrd for MyStruct {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(Ordering::Equal)
    }
}

impl PartialOrd for MyStruct2 {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.0.cmp(&other.0))
    }
}

impl Ord for MyStruct {
    fn cmp(&self, other: &Self) -> Ordering {
        Ordering::Equal
    }
}

impl Ord for MyStruct2 {
    fn cmp(&self, other: &Self) -> Ordering {
        self.0.cmp(&other.0)
    }

    fn max(self, other: Self) -> Self {
        other
    }
}

fn test_trait_model<T: Ord>(x: T) {
    let x1 = source(20).max(0);
    sink(x1); // $ hasValueFlow=20

    let x2 = (MyStruct {
        field1: source(23),
        field2: 0,
    })
    .max(MyStruct {
        field1: 0,
        field2: 0,
    });
    sink(x2.field1); // $ hasValueFlow=23

    let x3 = MyStruct2(source(24)).max(MyStruct2(0));
    sink(x3.0); // no flow, because the model does not apply when the target is in source code

    let x4 = source(25).max(1);
    sink(x4); // $ hasValueFlow=25

    let x5 = source(26).lt(&1);
    sink(x5); // $ hasTaintFlow=26

    let x6 = source(27) < 1;
    sink(x6); // $ hasTaintFlow=27
}

#[tokio::main]
async fn main() {
    test_identify();
    test_get_var_pos();
    test_set_var_pos();
    test_get_var_field();
    test_set_var_field();
    test_get_struct_field();
    test_set_struct_field();
    test_get_array_element();
    test_set_array_element();
    test_get_tuple_element();
    test_set_tuple_element();
    test_enum_source();
    test_enum_method_source();
    test_enum_sink();
    test_enum_method_sink();
    test_simple_source();
    test_simple_sink();
    test_get_async_number().await;
    test_arg_source();
    let dummy = Some(0); // ensure that the the `lang:core` crate is extracted
}
