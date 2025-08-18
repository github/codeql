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

struct S<T>(T);

impl<T> S<T> {
    fn foo(&self) -> &T {
        &self.0 // $ fieldof=S
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
    let _f1 = e1.deref(); // $ target=deref type=_f1:&T.char

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

    let z = MySmartPointer { value: S(0i64) };
    let z_ = z.foo(); // $ MISSING: target=foo type=z_:&T.i64
}

mod implicit_deref_coercion_cycle {
    use std::collections::HashMap;

    #[derive(Hash, PartialEq, Eq, PartialOrd, Ord, Debug, Clone, Copy)]
    pub struct Key {}

    // This example can trigger a cycle in type inference due to an implicit
    // dereference if we are not careful and accurate enough.
    //
    // To explain how a cycle might happen, we let `[V]` denote the type of the
    // type parameter `V` of `key_to_key` (i.e., the type of the values in the
    // map) and `[key]` denote the type of `key`.
    //
    // 1. From the first two lines we infer `[V] = &Key` and `[key] = &Key`
    // 2. At the 3. line we infer the type of `ref_key` to be `&[V]`.
    // 3. At the 4. line we impose the equality `[key] = &[V]`, not accounting
    //    for the implicit deref caused by a coercion.
    // 4. At the last line we infer `[key] = [V]`.
    //
    // Putting the above together we have `[V] = [key] = &[V]` which is a cycle.
    // This means that `[key]` is both `&Key`, `&&Key`, `&&&Key`, and so on ad
    // infinitum.

    #[rustfmt::skip]
    pub fn test() {
        let mut key_to_key = HashMap::<&Key, &Key>::new(); // $ target=new
        let mut key = &Key {}; // Initialize key2 to a reference
        if let Some(ref_key) = key_to_key.get(key) { // $ target=get
            // Below `ref_key` is implicitly dereferenced from `&&Key` to `&Key`
            key = ref_key;
        }
        key_to_key.insert(key, key); // $ target=insert
    }
}

mod ref_vs_mut_ref {
    trait MyTrait1<T> {
        fn foo(self) -> T;
    }

    struct S;

    impl MyTrait1<S> for &S {
        // MyTrait1::foo1
        fn foo(self) -> S {
            S
        }
    }

    impl MyTrait1<i64> for &mut S {
        // MyTrait1::foo2
        fn foo(self) -> i64 {
            42
        }
    }

    trait MyTrait2<T1, T2> {
        fn bar(self, arg: T1) -> T2;
    }

    impl MyTrait2<&S, S> for S {
        // MyTrait2::bar1
        fn bar(self, arg: &S) -> S {
            S
        }
    }

    impl MyTrait2<&mut S, i64> for S {
        // MyTrait2::bar2
        fn bar(self, arg: &mut S) -> i64 {
            42
        }
    }

    pub fn test() {
        let x = (&S).foo(); // $ target=MyTrait1::foo1 type=x:S $ SPURIOUS: target=MyTrait1::foo2
        let y = S.foo(); // $ target=MyTrait1::foo1 type=y:S $ SPURIOUS: target=MyTrait1::foo2
        let z = (&mut S).foo(); // $ target=MyTrait1::foo2 type=z:i64 $ SPURIOUS: target=MyTrait1::foo1

        let x = S.bar(&S); // $ target=MyTrait2::bar1 type=x:S $ SPURIOUS: target=MyTrait2::bar2
        let y = S.bar(&mut S); // $ target=MyTrait2::bar2 type=y:i64 $ SPURIOUS: target=MyTrait2::bar1
    }
}

// from https://doc.rust-lang.org/reference/expressions/method-call-expr.html#r-expr.method.candidate-search
mod rust_reference_example {
    struct Foo {}

    trait Bar {
        fn bar(&self);
    }

    impl Foo {
        // bar1
        fn bar(&mut self) {
            println!("In struct impl!")
        }
    }

    impl Bar for Foo {
        // bar2
        fn bar(&self) {
            println!("In trait impl!")
        }
    }

    pub fn main() {
        let mut f = Foo {};
        f.bar(); // $ SPURIOUS: target=bar1 $ MISSING: target=bar2
    }
}

pub fn test() {
    explicit_monomorphic_dereference(); // $ target=explicit_monomorphic_dereference
    explicit_polymorphic_dereference(); // $ target=explicit_polymorphic_dereference
    explicit_ref_dereference(); // $ target=explicit_ref_dereference
    explicit_box_dereference(); // $ target=explicit_box_dereference
    implicit_dereference(); // $ target=implicit_dereference
    implicit_deref_coercion_cycle::test(); // $ target=test
    ref_vs_mut_ref::test(); // $ target=test
    rust_reference_example::main(); // $ target=main
}
