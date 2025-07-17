// Test cases for type inference and method resolution with `dyn` types

use std::fmt::Debug;

trait MyTrait1 {
    // MyTrait1::m
    fn m(&self) -> String;
}

trait GenericGet<A> {
    // GenericGet::get
    fn get(&self) -> A;
}

#[derive(Clone, Debug)]
struct MyStruct {
    value: i32,
}

impl MyTrait1 for MyStruct {
    // MyStruct1::m
    fn m(&self) -> String {
        format!("MyTrait1: {}", self.value) // $ fieldof=MyStruct
    }
}

#[derive(Clone, Debug)]
struct GenStruct<A: Clone + Debug> {
    value: A,
}

impl<A: Clone + Debug> GenericGet<A> for GenStruct<A> {
    // GenStruct<A>::get
    fn get(&self) -> A {
        self.value.clone() // $ fieldof=GenStruct target=clone
    }
}

fn get_a<A, G: GenericGet<A> + ?Sized>(a: &G) -> A {
    a.get() // $ target=GenericGet::get
}

fn get_box_trait<A: Clone + Debug + 'static>(a: A) -> Box<dyn GenericGet<A>> {
    Box::new(GenStruct { value: a }) // $ target=new
}

fn test_basic_dyn_trait(obj: &dyn MyTrait1) {
    let _result = (*obj).m(); // $ target=deref MISSING: target=MyTrait1::m type=_result:String
}

fn test_generic_dyn_trait(obj: &dyn GenericGet<String>) {
    let _result1 = (*obj).get(); // $ target=deref MISSING: target=GenericGet::get type=_result1:String
    let _result2 = get_a(obj); // $ target=get_a MISSING: type=_result2:String
}

fn test_poly_dyn_trait() {
    let obj = get_box_trait(true); // $ target=get_box_trait
    let _result = (*obj).get(); // $ target=deref MISSING: target=GenericGet::get type=_result:bool
}

pub fn test() {
    test_basic_dyn_trait(&MyStruct { value: 42 }); // $ target=test_basic_dyn_trait
    test_generic_dyn_trait(&GenStruct {
        value: "".to_string(),
    }); // $ target=test_generic_dyn_trait
    test_poly_dyn_trait(); // $ target=test_poly_dyn_trait
}
