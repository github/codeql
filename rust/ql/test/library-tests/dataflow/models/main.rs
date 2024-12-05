fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
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

fn main() {
    test_identify();
    test_get_var_pos();
    test_set_var_pos();
    test_get_var_field();
    test_set_var_field();
    let dummy = Some(0); // ensure that the the `lang:core` crate is extracted
}
