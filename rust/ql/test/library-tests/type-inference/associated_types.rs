#[derive(Debug, Default, Copy, Clone)]
struct Wrapper<A>(A);

impl<A> Wrapper<A> {
    fn unwrap(self) -> A {
        self.0 // $ fieldof=Wrapper
    }
}

#[derive(Debug, Default, Clone, Copy)]
struct S;

#[derive(Debug, Default)]
struct S2;

#[derive(Debug, Default)]
struct S3;

trait GetSet {
    type Output;

    // GetSet::get
    fn get(&self) -> Self::Output;

    // GetSet::set
    fn set(&self, _a: Self::Output) {}
}

fn get<O, T: GetSet<Output = O> + ?Sized>(item: &T) -> O {
    item.get() // $ target=GetSet::get
}

trait AnotherGet: GetSet {
    type AnotherOutput;

    // AnotherGet::get_another
    fn get_another(&self) -> Self::AnotherOutput;
}

impl GetSet for S {
    type Output = S3;

    // S::get
    fn get(&self) -> Self::Output {
        S3
    }
}

impl AnotherGet for S {
    type AnotherOutput = bool;

    // S::get_another
    fn get_another(&self) -> Self::AnotherOutput {
        true
    }
}

impl<T: Copy> GetSet for Wrapper<T> {
    type Output = T;

    // Wrapper::get
    fn get(&self) -> Self::Output {
        self.0 // $ fieldof=Wrapper
    }
}

struct Odd<OddT>(OddT);

impl GetSet for Odd<i32> {
    type Output = bool;

    fn get(&self) -> Self::Output {
        true
    }
}

impl GetSet for Odd<bool> {
    type Output = char;

    fn get(&self) -> Self::Output {
        'a'
    }
}

mod default_method_using_associated_type {
    use super::*;

    trait MyTrait {
        type AssociatedType;

        // MyTrait::m1
        fn m1(self) -> Self::AssociatedType;

        fn m2(self) -> Self::AssociatedType
        where
            Self::AssociatedType: Default,
            Self: Sized,
        {
            self.m1(); // $ target=MyTrait::m1 type=self.m1():AssociatedType[MyTrait]
            let _default = Self::AssociatedType::default(); // $ MISSING: target=default _default:AssociatedType
            Self::AssociatedType::default() // $ MISSING: target=default
        }
    }

    impl MyTrait for S {
        type AssociatedType = S3;

        // S::m1
        fn m1(self) -> Self::AssociatedType {
            S3
        }
    }

    impl MyTrait for S2 {
        // Associated type definition with a type argument
        type AssociatedType = Wrapper<S2>;

        fn m1(self) -> Self::AssociatedType {
            Wrapper(self)
        }
    }

    pub fn test() {
        let x1 = S;
        // Call to method in `impl` block
        println!("{:?}", x1.m1()); // $ target=S::m1 type=x1.m1():S3

        let x2 = S;
        // Call to default method in `trait` block
        let y = x2.m2(); // $ target=m2 type=y:S3
        println!("{:?}", y);

        let x5 = S2;
        println!("{:?}", x5.m1()); // $ target=m1 type=x5.m1():A.S2
        let x6 = S2;
        println!("{:?}", x6.m2()); // $ target=m2 type=x6.m2():A.S2
    }
}

mod concrete_type_access_associated_type {
    use super::*;

    fn using_as(
        a: <S as GetSet>::Output,
        b: <Wrapper<i32> as GetSet>::Output,
        c: <Odd<i32> as GetSet>::Output,
        d: <Odd<bool> as GetSet>::Output,
    ) {
        let _a = a; // $ type=_a:S3
        let _b = b; // $ type=_b:i32
        let _c = c; // $ type=_c:bool
        let _d = d; // $ type=_d:char
    }

    // NOTE: The below seems like it should work, but is currently rejected by
    // the Rust compiler. This behavior does not seem to be documented and
    // there's an open issue about it:
    // https://github.com/rust-lang/rust/issues/104119
    // fn without_as(
    //     a: S::Output,
    //     b: Wrapper<i32>::Output,
    //     c: Odd<i32>::Output,
    //     d: Odd<bool>::Output,
    // ) {
    //     let _a = a; // $ type=_a:S3
    //     let _b = b; // $ type=_b:i32
    //     let _c = c; // $ type=_c:bool
    //     let _d = d; // $ type=_d:char
    // }

    impl Odd<i32> {
        // Odd<i32>::proj
        fn proj(&self) -> <Self as GetSet>::Output {
            let x = Default::default(); // $ target=default
            x // $ type=x:bool
        }
    }

    impl Odd<bool> {
        // Odd<bool>::proj
        fn proj(&self) -> <Self as GetSet>::Output {
            let x = Default::default(); // $ target=default
            x // $ type=x:char
        }
    }

    pub fn test() {
        using_as(S3, 1, true, 'a'); // $ target=using_as

        let _a = Odd(42i32).proj(); // $ target=Odd<i32>::proj type=_a:bool
        let _b = Odd(true).proj(); // $ target=Odd<bool>::proj type=_b:char
    }
}

// Tests a `<Type as Trait>::Assoc` type mention where the `Trait` type mention
// contains a generic.
//
// In `convert` below the type of `<S as Trans<T>>::Output` depends on how
// `convert` is called and thus the correct type cannot be determined when the
// `TypeMention` is constructed.
mod concrete_type_as_generic_access_associated_type {
    use super::*;

    trait Trans<T> {
        type Output;
        fn through(t: T) -> Self::Output;
    }

    impl Trans<bool> for S {
        type Output = i32;
        fn through(t: bool) -> Self::Output {
            if t {
                1
            } else {
                0
            }
        }
    }

    impl Trans<i32> for S {
        type Output = bool;
        fn through(t: i32) -> Self::Output {
            t != 0 // $ target=ne
        }
    }

    impl S {
        // S::convert
        fn convert<T>(&self, t: T) -> <S as Trans<T>>::Output
        where
            Self: Trans<T>,
        {
            S::through(t)
        }
    }

    pub fn test() {
        let s = S;
        let _a = s.convert(true); // $ target=S::convert type=_a:i32 SPURIOUS: bool
        let _b = s.convert(42); // $ target=S::convert type=_b:bool SPURIOUS: i32
    }
}

// Tests for signatures that access associated types on type parameters
mod type_param_access_associated_type {
    use super::*;

    fn tp_with_as<T: GetSet>(thing: T) -> <T as GetSet>::Output {
        thing.get() // $ target=GetSet::get
    }

    fn tp_without_as<T: GetSet>(thing: T) -> T::Output {
        thing.get() // $ target=GetSet::get
    }

    fn tp_assoc_from_supertrait<T: AnotherGet>(thing: T) -> (T::Output, T::AnotherOutput) {
        (
            thing.get(),         // $ target=GetSet::get
            thing.get_another(), // $ target=AnotherGet::get_another
        )
    }

    // Associated type accessed on a type parameter of an impl block
    impl<TI> Wrapper<TI>
    where
        TI: GetSet,
    {
        fn extract(&self) -> TI::Output {
            self.0.get() // $ fieldof=Wrapper target=GetSet::get
        }
    }

    // Associated type accessed on another associated type

    fn tp_nested_assoc_type<T: GetSet>(thing: T) -> <<T as GetSet>::Output as GetSet>::Output
    where
        <T as GetSet>::Output: GetSet,
    {
        thing.get().get() // $ target=GetSet::get target=GetSet::get
    }

    pub trait GetSetWrap {
        type Assoc: GetSet;

        // GetSetWrap::get_wrap
        fn get_wrap(&self) -> Self::Assoc;
    }

    impl GetSetWrap for S {
        type Assoc = S;

        // S::get_wrap
        fn get_wrap(&self) -> Self::Assoc {
            S
        }
    }

    // Nested associated type accessed on a type parameter of an impl block
    impl<TI> Wrapper<TI>
    where
        TI: GetSetWrap,
    {
        fn extract2(&self) -> <<TI as GetSetWrap>::Assoc as GetSet>::Output {
            self.0.get_wrap().get() // $ fieldof=Wrapper target=GetSetWrap::get_wrap $ MISSING: target=GetSet::get
        }
    }

    pub fn test() {
        let _o1 = tp_with_as(S); // $ target=tp_with_as type=_o1:S3
        let _o2 = tp_without_as(S); // $ target=tp_without_as type=_o2:S3
        let (
            _o3, // $ MISSING: type=_o3:S3
            _o4, // $ type=_o4:bool
        ) = tp_assoc_from_supertrait(S); // $ target=tp_assoc_from_supertrait

        let _o5 = tp_nested_assoc_type(Wrapper(S)); // $ target=tp_nested_assoc_type MISSING: type=_o5:S3

        let w = Wrapper(S);
        let _extracted = w.extract(); // $ target=extract type=_extracted:S3

        let _extracted2 = w.extract2(); // $ target=extract2 MISSING: type=_extracted2:S3
    }
}

// Tests for specifying associated types using equalities, e.g., `Trait<AssocType = Type>`
mod equality_on_associated_type {
    use super::*;

    fn _in_same_trait<T>(x: T)
    where
        T: GetSet<Output = char>,
    {
        let _a = x.get(); // $ target=GetSet::get type=_a:char
    }

    // Here we specify `Output` from `GetSet` through the subtrait `AnotherGet`.
    fn _in_subtrait<T>(x: T)
    where
        T: AnotherGet<Output = i32, AnotherOutput = bool>,
    {
        let _a1 = x.get(); // $ target=GetSet::get type=_a1:i32
        let _a2 = get(&x); // $ target=get type=_a2:i32
        let _b = x.get_another(); // $ type=_b:bool target=AnotherGet::get_another
    }

    // Here we specify the associated types as two separate trait bounds
    fn _two_bounds<T>(x: T)
    where
        T: AnotherGet<AnotherOutput = bool>,
        T: GetSet<Output = i32>,
    {
        let _a1 = x.get(); // $ target=GetSet::get type=_a1:i32
        let _a2 = get(&x); // $ target=get type=_a2:i32
        let _b = x.get_another(); // $ type=_b:bool target=AnotherGet::get_another
    }

    trait AssocNameClash: GetSet {
        type Output; // This name clashes with GetSet::Output

        // AssocNameClash::get2
        fn get2(&self) -> <Self as AssocNameClash>::Output;
    }

    fn _two_bounds_name_clash<T>(x: T)
    where
        T: AssocNameClash<Output = char>,
        T: GetSet<Output = i32>,
    {
        let _a = x.get(); // $ type=_a:i32 target=GetSet::get
        let _b = x.get2(); // $ target=AssocNameClash::get2 type=_b:char
    }
}

mod generic_associated_type {
    use super::*;

    trait MyTraitAssoc2 {
        type GenericAssociatedType<AssociatedParam>;

        // MyTraitAssoc2::put
        fn put<A>(&self, a: A) -> Self::GenericAssociatedType<A>;

        // MyTraitAssoc2::put_two
        fn put_two<A>(&self, a: A, b: A) -> Self::GenericAssociatedType<A> {
            self.put(a); // $ target=MyTraitAssoc2::put
            self.put(b) // $ target=MyTraitAssoc2::put
        }
    }

    impl MyTraitAssoc2 for S {
        // Associated type with a type parameter
        type GenericAssociatedType<AssociatedParam> = Wrapper<AssociatedParam>;

        // S::put
        fn put<A>(&self, a: A) -> Wrapper<A> {
            Wrapper(a)
        }
    }

    pub fn test() {
        let s = S;
        // Call to the method in `impl` block
        let _g1 = s.put(1i32); // $ target=S::put type=_g1:A.i32

        // Call to default implementation in `trait` block
        let _g2 = s.put_two(true, false); // $ target=MyTraitAssoc2::put_two MISSING: type=_g2:A.bool
    }
}

mod multiple_associated_types {
    use super::*;

    // A generic trait with multiple associated types.
    trait TraitMultipleAssoc<TrG> {
        type Assoc1;
        type Assoc2;

        fn get_zero(&self) -> TrG;

        fn get_one(&self) -> Self::Assoc1;

        fn get_two(&self) -> Self::Assoc2;
    }

    impl TraitMultipleAssoc<S3> for S3 {
        type Assoc1 = S;
        type Assoc2 = S2;

        fn get_zero(&self) -> S3 {
            S3
        }

        fn get_one(&self) -> Self::Assoc1 {
            S
        }

        fn get_two(&self) -> Self::Assoc2 {
            S2
        }
    }

    pub fn test() {
        let _assoc_zero = S3.get_zero(); // $ target=get_zero type=_assoc_zero:S3
        let _assoc_one = S3.get_one(); // $ target=get_one type=_assoc_one:S
        let _assoc_two = S3.get_two(); // $ target=get_two type=_assoc_two:S2
    }
}

mod associated_type_in_supertrait {
    use super::*;

    trait Subtrait: GetSet {
        // Subtrait::get_content
        fn get_content(&self) -> Self::Output;
    }

    // A subtrait declared using a `where` clause.
    trait Subtrait2
    where
        Self: GetSet,
    {
        // Subtrait2::insert_two
        fn insert_two(&self, c1: Self::Output, c2: Self::Output) {
            self.set(c1); // $ target=GetSet::set
            self.set(c2); // $ target=GetSet::set
        }
    }

    struct MyType<T>(T);

    impl<T: Copy> GetSet for MyType<T> {
        type Output = T;

        fn get(&self) -> Self::Output {
            self.0 // $ fieldof=MyType
        }

        fn set(&self, _content: Self::Output) {
            println!("Inserting content: ");
        }
    }

    impl<T: Copy> Subtrait for MyType<T> {
        // MyType::get_content
        fn get_content(&self) -> Self::Output {
            (*self).0 // $ fieldof=MyType target=deref
        }
    }

    impl Subtrait for Odd<i32> {
        // Odd<i32>::get_content
        fn get_content(&self) -> Self::Output {
            // let _x = Self::get(self);
            Default::default() // $ target=default
        }
    }

    impl Subtrait for Odd<bool> {
        // Odd<bool>::get_content
        fn get_content(&self) -> Self::Output {
            Default::default() // $ target=default
        }
    }

    fn get_content<T: Subtrait>(item: &T) -> T::Output {
        item.get_content() // $ target=Subtrait::get_content
    }

    fn insert_three<T: Subtrait2>(item: &T, c1: T::Output, c2: T::Output, c3: T::Output) {
        item.set(c1); // $ target=GetSet::set
        item.insert_two(c2, c3); // $ target=Subtrait2::insert_two
    }

    pub fn test() {
        let item1 = MyType(42i64);
        let _content1 = item1.get_content(); // $ target=MyType::get_content type=_content1:i64

        let item2 = MyType(true);
        let _content2 = get_content(&item2); // $ target=get_content MISSING: type=_content2:bool

        let _content3 = Odd(42i32).get_content(); // $ target=Odd<i32>::get_content type=_content3:bool
        let _content4 = Odd(true).get_content(); // $ target=Odd<bool>::get_content type=_content4:char
    }
}

mod generic_associated_type_name_clash {
    use super::*;

    struct ST<T>(T);

    impl<Output: Copy> GetSet for ST<Output> {
        // This is not a recursive type, the `Output` on the right-hand side
        // refers to the type parameter of the impl block just above.
        type Output = Result<Output, Output>;

        fn get(&self) -> Self::Output {
            Ok(self.0) // $ fieldof=ST type=Ok(...):Result type=Ok(...):T.Output type=Ok(...):E.Output
        }
    }

    pub fn test() {
        let _y = ST(true).get(); // $ type=_y:Result type=_y:T.bool type=_y:E.bool target=get
    }
}

// Tests for associated types in `dyn` trait objects
mod dyn_trait {
    use super::*;

    fn _assoc_type_from_trait(t: &dyn GetSet<Output = i32>) {
        // Explicit deref
        let _a1 = (*t).get(); // $ target=deref target=GetSet::get type=_a1:i32

        // Auto-deref
        let _a2 = t.get(); // $ target=GetSet::get type=_a2:i32

        let _a3 = get(t); // $ target=get type=_a3:i32
    }

    fn _assoc_type_from_supertrait(t: &dyn AnotherGet<Output = i32, AnotherOutput = bool>) {
        let _a1 = (*t).get(); // $ target=deref target=GetSet::get type=_a1:i32
        let _a2 = t.get(); // $ target=GetSet::get type=_a2:i32
        let _a3 = get(t); // $ target=get type=_a3:i32
        let _b1 = (*t).get_another(); // $ target=deref target=AnotherGet::get_another type=_b1:bool
        let _b2 = t.get_another(); // $ target=AnotherGet::get_another type=_b2:bool
    }
}

pub fn test() {
    default_method_using_associated_type::test(); // $ target=test
    concrete_type_access_associated_type::test(); // $ target=test
    concrete_type_as_generic_access_associated_type::test(); // $ target=test
    type_param_access_associated_type::test(); // $ target=test
    generic_associated_type::test(); // $ target=test
    multiple_associated_types::test(); // $ target=test
    associated_type_in_supertrait::test(); // $ target=test
    generic_associated_type_name_clash::test(); // $ target=test
}
