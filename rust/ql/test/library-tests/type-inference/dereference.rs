/// This file contains tests for dereferencing with through the `Deref` trait.
use std::ops::Deref;

struct MyIntPointer {
    value: i64,
}

impl Deref for MyIntPointer {
    type Target = i64;

    // MyIntPointer::deref
    fn deref(&self) -> &i64 {
        &self.value // $ fieldof=MyIntPointer
    }
}

struct MySmartPointer<T> {
    value: T,
}

impl<T> Deref for MySmartPointer<T> {
    type Target = T;

    // MySmartPointer::deref
    fn deref(&self) -> &T {
        &self.value // $ fieldof=MySmartPointer
    }
}

fn explicit_monomorphic_dereference() {
    // Dereference with method call
    let a1 = MyIntPointer { value: 34i64 };
    let _b1 = a1.deref(); // $ target=MyIntPointer::deref type=_b1:&T.i64

    // Dereference with overloaded dereference operator
    let a2 = MyIntPointer { value: 34i64 };
    let _b2 = *a2; // $ target=MyIntPointer::deref type=_b2:i64

    // Call method on explicitly dereferenced value
    let a3 = MyIntPointer { value: 34i64 };
    let _b3 = (*a3).is_positive(); // $ target=MyIntPointer::deref target=is_positive type=_b3:bool
}

fn explicit_polymorphic_dereference() {
    // Explicit dereference with type parameter
    let c1 = MySmartPointer { value: 'a' };
    let _d1 = c1.deref(); // $ target=MySmartPointer::deref type=_d1:&T.char

    // Explicit dereference with type parameter
    let c2 = MySmartPointer { value: 'a' };
    let _d2 = *c2; // $ target=MySmartPointer::deref type=_d2:char

    // Call method on explicitly dereferenced value with type parameter
    let c3 = MySmartPointer { value: 34i64 };
    let _d3 = (*c3).is_positive(); // $ target=MySmartPointer::deref target=is_positive type=_d3:bool
}

fn explicit_ref_dereference() {
    // Explicit dereference with type parameter
    let e1 = &'a';
    let _f1 = e1.deref(); // $ target=deref MISSING: type=_f1:&T.char

    // Explicit dereference with type parameter
    let e2 = &'a';
    let _f2 = *e2; // $ target=deref type=_f2:char

    // Call method on explicitly dereferenced value with type parameter
    let e3 = &34i64;
    let _f3 = (*e3).is_positive(); // $ target=deref target=is_positive type=_f3:bool
}

fn explicit_box_dereference() {
    // Explicit dereference with type parameter
    let g1: Box<char> = Box::new('a'); // $ target=new
    let _h1 = g1.deref(); // $ target=deref type=_h1:&T.char

    // Explicit dereference with type parameter
    let g2: Box<char> = Box::new('a'); // $ target=new
    let _h2 = *g2; // $ target=deref type=_h2:char

    // Call method on explicitly dereferenced value with type parameter
    let g3: Box<i64> = Box::new(34i64); // $ target=new
    let _h3 = (*g3).is_positive(); // $ target=deref target=is_positive type=_h3:bool
}

fn implicit_dereference() {
    // Call method on implicitly dereferenced value
    let x = MyIntPointer { value: 34i64 };
    let _y = x.is_positive(); // $ MISSING: target=is_positive type=_y:bool

    // Call method on implicitly dereferenced value
    let x = MySmartPointer { value: 34i64 };
    let _y = x.is_positive(); // $ MISSING: target=is_positive type=_y:bool
}

pub fn test() {
    explicit_monomorphic_dereference(); // $ target=explicit_monomorphic_dereference
    explicit_polymorphic_dereference(); // $ target=explicit_polymorphic_dereference
    explicit_ref_dereference(); // $ target=explicit_ref_dereference
    explicit_box_dereference(); // $ target=explicit_box_dereference
    implicit_dereference(); // $ target=implicit_dereference
}
