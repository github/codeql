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

trait AssocTrait<GP> {
    type AP;
    // AssocTrait::get
    fn get(&self) -> (GP, Self::AP);
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

impl<GGP> AssocTrait<GGP> for GenStruct<GGP>
where
    GGP: Clone + Debug,
{
    type AP = bool;
    // GenStruct<GGP>::get
    fn get(&self) -> (GGP, bool) {
        (self.value.clone(), true) // $ fieldof=GenStruct target=clone
    }
}

fn get_a<A, G: GenericGet<A> + ?Sized>(a: &G) -> A {
    a.get() // $ target=GenericGet::get
}

fn get_box_trait<A: Clone + Debug + 'static>(a: A) -> Box<dyn GenericGet<A>> {
    Box::new(GenStruct { value: a }) // $ target=new
}

fn test_basic_dyn_trait(obj: &dyn MyTrait1) {
    let _result = (*obj).m(); // $ target=deref target=MyTrait1::m type=_result:String
}

fn test_generic_dyn_trait(obj: &dyn GenericGet<String>) {
    let _result1 = (*obj).get(); // $ target=deref target=GenericGet::get type=_result1:String
    let _result2 = get_a(obj); // $ target=get_a type=_result2:String
}

fn test_poly_dyn_trait() {
    let obj = get_box_trait(true); // $ target=get_box_trait
    let _result = (*obj).get(); // $ target=deref target=GenericGet::get type=_result:bool
}

fn assoc_dyn_get<A, B>(a: &dyn AssocTrait<A, AP = B>) -> (A, B) {
    a.get() // $ target=AssocTrait::get
}

fn assoc_get<A, B, T: AssocTrait<A, AP = B> + ?Sized>(a: &T) -> (A, B) {
    a.get() // $ target=AssocTrait::get
}

fn test_assoc_type(obj: &dyn AssocTrait<i64, AP = bool>) {
    let (
        _gp, // $ type=_gp:i64
        _ap, // $ type=_ap:bool
    ) = (*obj).get(); // $ target=deref target=AssocTrait::get
    let (
        _gp, // $ type=_gp:i64
        _ap, // $ type=_ap:bool
    ) = assoc_dyn_get(obj); // $ target=assoc_dyn_get
    let (
        _gp, // $ type=_gp:i64
        _ap, // $ type=_ap:bool
    ) = assoc_get(obj); // $ target=assoc_get
}

pub fn test() {
    test_basic_dyn_trait(&MyStruct { value: 42 }); // $ target=test_basic_dyn_trait
    test_generic_dyn_trait(&GenStruct {
        value: "".to_string(),
    }); // $ target=test_generic_dyn_trait
    test_poly_dyn_trait(); // $ target=test_poly_dyn_trait
    test_assoc_type(&GenStruct { value: 100 }); // $ target=test_assoc_type
}
