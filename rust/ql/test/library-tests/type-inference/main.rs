#![feature(box_patterns)]
mod field_access {
    #[derive(Debug)]
    struct S;
    #[derive(Debug)]
    struct MyThing {
        a: S,
    }

    #[derive(Debug)]
    enum MyOption<T> {
        MyNone(),
        MySome(T),
    }

    #[derive(Debug)]
    struct GenericThing<A = bool> {
        a: A,
    }

    struct OptionS {
        a: MyOption<S>,
    }

    fn simple_field_access() {
        let x = MyThing { a: S };
        println!("{:?}", x.a); // $ fieldof=MyThing
    }

    fn default_field_access(x: GenericThing) {
        let a = x.a; // $ fieldof=GenericThing type=a:bool
        println!("{:?}", a);
    }

    fn generic_field_access() {
        // Explicit type argument
        let x = GenericThing::<S> { a: S }; // $ type=x:A.S
        println!("{:?}", x.a); // $ fieldof=GenericThing

        // Implicit type argument
        let y = GenericThing { a: S };
        println!("{:?}", x.a); // $ fieldof=GenericThing

        // The type of the field `a` can only be inferred from the concrete type
        // in the struct declaration.
        let x = OptionS {
            a: MyOption::MyNone(),
        };
        println!("{:?}", x.a); // $ fieldof=OptionS

        // The type of the field `a` can only be inferred from the type argument
        let x = GenericThing::<MyOption<S>> {
            a: MyOption::MyNone(),
        };
        println!("{:?}", x.a); // $ fieldof=GenericThing

        let mut x = GenericThing {
            a: MyOption::MyNone(),
        };
        // Only after this access can we infer the type parameter of `x`
        let a: MyOption<S> = x.a; // $ fieldof=GenericThing
        println!("{:?}", a);
    }

    pub fn f() {
        simple_field_access(); // $ target=simple_field_access
        generic_field_access(); // $ target=generic_field_access
    }
}

mod method_impl {
    pub struct Foo {}

    impl Foo {
        pub fn m1(self) -> Self {
            self
        }

        pub fn m2(self) -> Foo {
            self
        }
    }

    pub fn f() -> Foo {
        println!("main.rs::m1::f");
        let x = Foo {};
        let y: _ = Foo {};
        x
    }

    pub fn g(x: Foo, y: Foo) -> Foo {
        println!("main.rs::m1::g");
        x.m1(); // $ target=m1
        y.m2() // $ target=m2
    }
}

mod trait_impl {
    #[derive(Debug)]
    struct MyThing {
        field: bool,
    }

    trait MyTrait<B> {
        fn trait_method(self) -> B;
    }

    impl MyTrait<bool> for MyThing {
        // MyThing::trait_method
        fn trait_method(self) -> bool {
            self.field // $ fieldof=MyThing
        }
    }

    pub fn f() {
        let x = MyThing { field: true };
        let a = x.trait_method(); // $ type=a:bool target=MyThing::trait_method

        let y = MyThing { field: false };
        let b = MyTrait::trait_method(y); // $ type=b:bool target=MyThing::trait_method
    }
}

mod method_non_parametric_impl {
    #[derive(Debug)]
    struct MyThing<A> {
        a: A,
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    impl MyThing<S1> {
        // MyThing<S1>::m1
        fn m1(self) -> S1 {
            self.a // $ fieldof=MyThing
        }
    }

    impl MyThing<S2> {
        // MyThing<S2>::m1
        fn m1(self) -> Self {
            Self { a: self.a } // $ fieldof=MyThing
        }
    }

    impl<T> MyThing<T> {
        fn m2(self) -> T {
            self.a // $ fieldof=MyThing
        }
    }

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        // simple field access
        println!("{:?}", x.a); // $ fieldof=MyThing
        println!("{:?}", y.a); // $ fieldof=MyThing

        println!("{:?}", x.m1()); // $ target=MyThing<S1>::m1
        println!("{:?}", y.m1().a); // $ target=MyThing<S2>::m1 fieldof=MyThing

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2()); // $ target=m2
        println!("{:?}", y.m2()); // $ target=m2
    }
}

mod method_non_parametric_trait_impl {
    #[derive(Debug, Clone, Copy)]
    struct MyThing<A> {
        a: A,
    }

    #[derive(Debug, Clone, Copy)]
    struct MyPair<P1, P2> {
        p1: P1,
        p2: P2,
    }

    #[derive(Debug, Clone, Copy)]
    struct S1;
    #[derive(Debug, Clone, Copy)]
    struct S2;
    #[derive(Debug, Clone, Copy, Default)]
    struct S3;

    trait MyTrait<A> {
        fn m1(self) -> A;

        fn m2(self) -> Self
        where
            Self: Sized,
        {
            self
        }
    }

    trait MyProduct<A, B> {
        // MyProduct::fst
        fn fst(self) -> A;
        // MyProduct::snd
        fn snd(self) -> B;
    }

    fn call_trait_m1<T1, T2: MyTrait<T1>>(x: T2) -> T1 {
        x.m1() // $ target=m1
    }

    impl MyTrait<S1> for MyThing<S1> {
        // MyThing<S1>::m1
        fn m1(self) -> S1 {
            self.a // $ fieldof=MyThing
        }
    }

    impl MyTrait<Self> for MyThing<S2> {
        // MyThing<S2>::m1
        fn m1(self) -> Self {
            Self { a: self.a } // $ fieldof=MyThing
        }
    }

    // Implementation where the type parameter `TD` only occurs in the
    // implemented trait and not the implementing type.
    impl<TD> MyTrait<TD> for MyThing<S3>
    where
        TD: Default,
    {
        // MyThing<S3>::m1
        fn m1(self) -> TD {
            TD::default() // $ target=default
        }
    }

    impl<I> MyTrait<I> for MyPair<I, S1> {
        // MyTrait<I>::m1
        fn m1(self) -> I {
            self.p1 // $ fieldof=MyPair
        }
    }

    impl MyTrait<S3> for MyPair<S1, S2> {
        // MyTrait<S3>::m1
        fn m1(self) -> S3 {
            S3
        }
    }

    impl<TT> MyTrait<TT> for MyPair<MyThing<TT>, S3> {
        // MyTrait<TT>::m1
        fn m1(self) -> TT {
            let alpha = self.p1; // $ fieldof=MyPair
            alpha.a // $ fieldof=MyThing
        }
    }

    // This implementation only applies if the two type parameters are equal.
    impl<A> MyProduct<A, A> for MyPair<A, A> {
        // MyPair<A,A>::fst
        fn fst(self) -> A {
            self.p1 // $ fieldof=MyPair
        }

        // MyPair<A,A>::snd
        fn snd(self) -> A {
            self.p2 // $ fieldof=MyPair
        }
    }

    // This implementation swaps the type parameters.
    impl MyProduct<S1, S2> for MyPair<S2, S1> {
        // MyPair<S2,S1>::fst
        fn fst(self) -> S1 {
            self.p2 // $ fieldof=MyPair
        }

        // MyPair<S2,S1>::snd
        fn snd(self) -> S2 {
            self.p1 // $ fieldof=MyPair
        }
    }

    fn get_fst<V1, V2, P: MyProduct<V1, V2>>(p: P) -> V1 {
        p.fst() // $ target=MyProduct::fst
    }

    fn get_snd<V1, V2, P: MyProduct<V1, V2>>(p: P) -> V2 {
        p.snd() // $ target=MyProduct::snd
    }

    fn get_snd_fst<V0, V1, V2, P: MyProduct<V1, V2>>(p: MyPair<V0, P>) -> V1 {
        p.p2.fst() // $ fieldof=MyPair target=MyProduct::fst
    }

    trait ConvertTo<T> {
        // ConvertTo::convert_to
        fn convert_to(self) -> T;
    }

    impl<T: MyTrait<S1>> ConvertTo<S1> for T {
        // T::convert_to
        fn convert_to(self) -> S1 {
            self.m1() // $ target=m1
        }
    }

    fn convert_to<TS, T: ConvertTo<TS>>(thing: T) -> TS {
        thing.convert_to() // $ target=ConvertTo::convert_to
    }

    fn type_bound_type_parameter_impl<TP: MyTrait<S1>>(thing: TP) -> S1 {
        // The trait bound on `TP` makes the implementation of `ConvertTo` valid
        thing.convert_to() // $ MISSING: target=T::convert_to
    }

    pub fn f() {
        let thing_s1 = MyThing { a: S1 };
        let thing_s2 = MyThing { a: S2 };
        let thing_s3 = MyThing { a: S3 };

        // Tests for method resolution

        println!("{:?}", thing_s1.m1()); // $ target=MyThing<S1>::m1
        println!("{:?}", thing_s2.m1().a); // $ target=MyThing<S2>::m1 fieldof=MyThing
        let s3: S3 = thing_s3.m1(); // $ target=MyThing<S3>::m1
        println!("{:?}", s3);

        let p1 = MyPair { p1: S1, p2: S1 };
        println!("{:?}", p1.m1()); // $ target=MyTrait<I>::m1

        let p2 = MyPair { p1: S1, p2: S2 };
        println!("{:?}", p2.m1()); // $ target=MyTrait<S3>::m1

        let p3 = MyPair {
            p1: MyThing { a: S1 },
            p2: S3,
        };
        println!("{:?}", p3.m1()); // $ target=MyTrait<TT>::m1

        // These calls go to the first implementation of `MyProduct` for `MyPair`
        let a = MyPair { p1: S1, p2: S1 };
        let x = a.fst(); // $ target=MyPair<A,A>::fst
        println!("{:?}", x);
        let y = a.snd(); // $ target=MyPair<A,A>::snd
        println!("{:?}", y);

        // These calls go to the last implementation of `MyProduct` for
        // `MyPair`. The first implementation does not apply as the type
        // parameters of the implementation enforce that the two generics must
        // be equal.
        let b = MyPair { p1: S2, p2: S1 };
        let x = b.fst(); // $ target=MyPair<S2,S1>::fst
        println!("{:?}", x);
        let y = b.snd(); // $ target=MyPair<S2,S1>::snd
        println!("{:?}", y);

        // Tests for inference of type parameters based on trait implementations.

        let x = call_trait_m1(thing_s1); // $ type=x:S1 target=call_trait_m1
        println!("{:?}", x);
        let y = call_trait_m1(thing_s2); // $ type=y:MyThing type=y:A.S2 target=call_trait_m1
        println!("{:?}", y.a); // $ fieldof=MyThing

        // First implementation
        let a = MyPair { p1: S1, p2: S1 };
        let x = get_fst(a); // $ type=x:S1 target=get_fst
        println!("{:?}", x);
        let y = get_snd(a); // $ type=y:S1 target=get_snd
        println!("{:?}", y);

        // Second implementation
        let b = MyPair { p1: S2, p2: S1 };
        let x = get_fst(b); // $ type=x:S1 target=get_fst
        println!("{:?}", x);
        let y = get_snd(b); // $ type=y:S2 target=get_snd
        println!("{:?}", y);

        let c = MyPair {
            p1: S3,
            p2: MyPair { p1: S2, p2: S1 },
        };
        let x = get_snd_fst(c); // $ type=x:S1 target=get_snd_fst

        let thing = MyThing { a: S1 };
        let i = thing.convert_to(); // $ MISSING: type=i:S1 target=T::convert_to
        let j = convert_to(thing); // $ type=j:S1 target=convert_to
    }
}

mod impl_overlap {
    #[derive(Debug, Clone, Copy)]
    struct S1;

    trait OverlappingTrait {
        fn common_method(self) -> S1;

        fn common_method_2(self, s1: S1) -> S1;
    }

    impl OverlappingTrait for S1 {
        // <S1_as_OverlappingTrait>::common_method
        fn common_method(self) -> S1 {
            S1
        }

        // <S1_as_OverlappingTrait>::common_method_2
        fn common_method_2(self, s1: S1) -> S1 {
            S1
        }
    }

    impl S1 {
        // S1::common_method
        fn common_method(self) -> S1 {
            self
        }

        // S1::common_method_2
        fn common_method_2(self) -> S1 {
            self
        }
    }

    struct S2<T2>(T2);

    impl S2<i32> {
        // S2<i32>::common_method
        fn common_method(self) -> S1 {
            S1
        }

        // S2<i32>::common_method
        fn common_method_2(self) -> S1 {
            S1
        }
    }

    impl OverlappingTrait for S2<i32> {
        // <S2<i32>_as_OverlappingTrait>::common_method
        fn common_method(self) -> S1 {
            S1
        }

        // <S2<i32>_as_OverlappingTrait>::common_method_2
        fn common_method_2(self, s1: S1) -> S1 {
            S1
        }
    }

    impl OverlappingTrait for S2<S1> {
        // <S2<S1>_as_OverlappingTrait>::common_method
        fn common_method(self) -> S1 {
            S1
        }

        // <S2<S1>_as_OverlappingTrait>::common_method_2
        fn common_method_2(self, s1: S1) -> S1 {
            S1
        }
    }

    #[derive(Debug)]
    struct S3<T3>(T3);

    trait OverlappingTrait2<T> {
        fn m(&self, x: &T) -> &Self;
    }

    impl<T> OverlappingTrait2<T> for S3<T> {
        // <S3<T>_as_OverlappingTrait2<T>>::m
        fn m(&self, x: &T) -> &Self {
            self
        }
    }

    impl<T> S3<T> {
        // S3<T>::m
        fn m(&self, x: T) -> &Self {
            self
        }
    }

    pub fn f() {
        let x = S1;
        println!("{:?}", x.common_method()); // $ target=S1::common_method
        println!("{:?}", x.common_method_2()); // $ target=S1::common_method_2

        let y = S2(S1);
        println!("{:?}", y.common_method()); // $ target=<S2<S1>_as_OverlappingTrait>::common_method

        let z = S2(0);
        println!("{:?}", z.common_method()); // $ target=S2<i32>::common_method

        let w = S3(S1);
        println!("{:?}", w.m(x)); // $ target=S3<T>::m
    }
}

mod type_parameter_bounds {
    use std::fmt::Debug;

    #[derive(Debug)]
    struct S1;

    #[derive(Debug)]
    struct S2;

    // Two traits with the same method name.

    trait FirstTrait<FT> {
        // FirstTrait::method
        fn method(self) -> FT;
    }

    trait SecondTrait<ST> {
        // SecondTrait::method
        fn method(self) -> ST;
    }

    fn call_first_trait_per_bound<I: Debug, T: SecondTrait<I>>(x: T) {
        // The type parameter bound determines which method this call is resolved to.
        let s1 = x.method(); // $ target=SecondTrait::method
        println!("{:?}", s1); // $ type=s1:I
    }

    fn call_second_trait_per_bound<I: Debug, T: SecondTrait<I>>(x: T) {
        // The type parameter bound determines which method this call is resolved to.
        let s2 = x.method(); // $ target=SecondTrait::method
        println!("{:?}", s2); // $ type=s2:I
    }

    fn trait_bound_with_type<T: FirstTrait<S1>>(x: T) {
        let s = x.method(); // $ target=FirstTrait::method
        println!("{:?}", s); // $ type=s:S1
    }

    fn trait_per_bound_with_type<T: FirstTrait<S1>>(x: T) {
        let s = x.method(); // $ target=FirstTrait::method
        println!("{:?}", s); // $ type=s:S1
    }

    fn trait_per_where_bound_with_type<T>(x: T)
    where
        T: FirstTrait<S1>,
    {
        let s = x.method(); // $ target=FirstTrait::method
        println!("{:?}", s); // $ type=s:S1
    }

    trait Pair<P1 = bool, P2 = i64> {
        fn fst(self) -> P1;

        fn snd(self) -> P2;
    }

    fn trait_per_multiple_where_bounds_with_type<T>(x: T, y: T)
    where
        T: FirstTrait<S1>,
        T: Pair<S1, bool>,
    {
        let _ = x.fst(); // $ target=fst type=_:S1
        let _ = y.method(); // $ target=FirstTrait::method _:S1
    }

    fn call_trait_per_bound_with_type_1<T: Pair<S1, S2>>(x: T, y: T) {
        // The type in the type parameter bound determines the return type.
        let s1 = x.fst(); // $ target=fst type=s1:S1
        let s2 = y.snd(); // $ target=snd type=s2:S2
        println!("{:?}, {:?}", s1, s2);
    }

    fn call_trait_per_bound_with_type_2<T2: Debug, T: Pair<S1, T2>>(x: T, y: T) {
        // The type in the type parameter bound determines the return type.
        let s1 = x.fst(); // $ target=fst
        let s2 = y.snd(); // $ target=snd
        println!("{:?}, {:?}", s1, s2);
    }

    fn call_trait_per_bound_with_type_3<T: Pair>(x: T, y: T) {
        // The type in the type parameter bound determines the return type.
        let s1 = x.fst(); // $ target=fst type=s1:bool
        let s2 = y.snd(); // $ target=snd type=s2:i64
        println!("{:?}, {:?}", s1, s2);
    }

    fn call_trait_per_bound_with_type_4<T: Pair<u8>>(x: T, y: T) {
        // The type in the type parameter bound determines the return type.
        let s1 = x.fst(); // $ target=fst type=s1:u8
        let s2 = y.snd(); // $ target=snd type=s2:i64
        println!("{:?}, {:?}", s1, s2);
    }
}

mod function_trait_bounds {
    #[derive(Debug)]
    struct MyThing<T> {
        a: T,
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    trait MyTrait<A> {
        fn m1(self) -> A;

        fn m2(self) -> A
        where
            Self: Sized,
        {
            self.m1() // $ target=m1
        }
    }

    // Type parameter with bound occurs in the root of a parameter type.

    fn call_trait_m1<T1, T2: MyTrait<T1>>(x: T2) -> T1 {
        x.m1() // $ target=m1 type=x.m1():T1
    }

    // Type parameter with bound occurs nested within another type.

    fn call_trait_thing_m1<T1, T2: MyTrait<T1>>(x: MyThing<T2>) -> T1 {
        x.a.m1() // $ fieldof=MyThing target=m1
    }

    impl<T> MyTrait<T> for MyThing<T> {
        fn m1(self) -> T {
            self.a // $ fieldof=MyThing
        }
    }

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1()); // $ target=m1
        println!("{:?}", y.m1()); // $ target=m1

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2()); // $ target=m2
        println!("{:?}", y.m2()); // $ target=m2

        let x2 = MyThing { a: S1 };
        let y2 = MyThing { a: S2 };

        println!("{:?}", call_trait_m1(x2)); // $ target=call_trait_m1
        println!("{:?}", call_trait_m1(y2)); // $ target=call_trait_m1

        let x3 = MyThing {
            a: MyThing { a: S1 },
        };
        let y3 = MyThing {
            a: MyThing { a: S2 },
        };

        let a = call_trait_thing_m1(x3); // $ type=a:S1 target=call_trait_thing_m1
        println!("{:?}", a);
        let b = call_trait_thing_m1(y3); // $ type=b:S2 target=call_trait_thing_m1
        println!("{:?}", b);
    }
}

mod associated_type_in_trait {
    #[derive(Debug)]
    struct Wrapper<A> {
        field: A,
    }

    impl<A> Wrapper<A> {
        fn unwrap(self) -> A {
            self.field // $ fieldof=Wrapper
        }
    }

    trait MyTrait {
        type AssociatedType;

        // MyTrait::m1
        fn m1(self) -> Self::AssociatedType;

        fn m2(self) -> Self::AssociatedType
        where
            Self::AssociatedType: Default,
            Self: Sized,
        {
            self.m1(); // $ target=MyTrait::m1 type=self.m1():AssociatedType
            Self::AssociatedType::default()
        }
    }

    trait MyTraitAssoc2 {
        type GenericAssociatedType<AssociatedParam>;

        // MyTrait::put
        fn put<A>(&self, a: A) -> Self::GenericAssociatedType<A>;

        fn putTwo<A>(&self, a: A, b: A) -> Self::GenericAssociatedType<A> {
            self.put(a); // $ target=MyTrait::put
            self.put(b) // $ target=MyTrait::put
        }
    }

    // A generic trait with multiple associated types.
    trait TraitMultipleAssoc<TrG> {
        type Assoc1;
        type Assoc2;

        fn get_zero(&self) -> TrG;

        fn get_one(&self) -> Self::Assoc1;

        fn get_two(&self) -> Self::Assoc2;
    }

    #[derive(Debug, Default)]
    struct S;

    #[derive(Debug, Default)]
    struct S2;

    #[derive(Debug, Default)]
    struct AT;

    impl MyTrait for S {
        type AssociatedType = AT;

        // S::m1
        fn m1(self) -> Self::AssociatedType {
            AT
        }
    }

    impl MyTraitAssoc2 for S {
        // Associated type with a type parameter
        type GenericAssociatedType<AssociatedParam> = Wrapper<AssociatedParam>;

        // S::put
        fn put<A>(&self, a: A) -> Wrapper<A> {
            Wrapper { field: a }
        }
    }

    impl MyTrait for S2 {
        // Associated type definition with a type argument
        type AssociatedType = Wrapper<S2>;

        fn m1(self) -> Self::AssociatedType {
            Wrapper { field: self }
        }
    }

    // NOTE: This implementation is just to make it possible to call `m2` on `S2.`
    impl Default for Wrapper<S2> {
        fn default() -> Self {
            Wrapper { field: S2 }
        }
    }

    // Function that returns an associated type from a trait bound

    fn g<T: MyTrait>(thing: T) -> <T as MyTrait>::AssociatedType {
        thing.m1() // $ target=MyTrait::m1
    }

    impl TraitMultipleAssoc<AT> for AT {
        type Assoc1 = S;
        type Assoc2 = S2;

        fn get_zero(&self) -> AT {
            AT
        }

        fn get_one(&self) -> Self::Assoc1 {
            S
        }

        fn get_two(&self) -> Self::Assoc2 {
            S2
        }
    }

    pub fn f() {
        let x1 = S;
        // Call to method in `impl` block
        println!("{:?}", x1.m1()); // $ target=S::m1 type=x1.m1():AT

        let x2 = S;
        // Call to default method in `trait` block
        let y = x2.m2(); // $ target=m2 type=y:AT
        println!("{:?}", y);

        let x3 = S;
        // Call to the method in `impl` block
        println!("{:?}", x3.put(1).unwrap()); // $ target=S::put target=unwrap

        // Call to default implementation in `trait` block
        println!("{:?}", x3.putTwo(2, 3).unwrap()); // $ target=putTwo target=unwrap

        let x4 = g(S); // $ target=g $ MISSING: type=x4:AT
        println!("{:?}", x4);

        let x5 = S2;
        println!("{:?}", x5.m1()); // $ target=m1 type=x5.m1():A.S2
        let x6 = S2;
        println!("{:?}", x6.m2()); // $ target=m2 type=x6.m2():A.S2

        let assoc_zero = AT.get_zero(); // $ target=get_zero type=assoc_zero:AT
        let assoc_one = AT.get_one(); // $ target=get_one type=assoc_one:S
        let assoc_two = AT.get_two(); // $ target=get_two type=assoc_two:S2
    }
}

mod associated_type_in_supertrait {
    trait Supertrait {
        type Content;
        // Supertrait::insert
        fn insert(&self, content: Self::Content);
    }

    trait Subtrait: Supertrait {
        // Subtrait::get_content
        fn get_content(&self) -> Self::Content;
    }

    // A subtrait declared using a `where` clause.
    trait Subtrait2
    where
        Self: Supertrait,
    {
        // Subtrait2::insert_two
        fn insert_two(&self, c1: Self::Content, c2: Self::Content) {
            self.insert(c1); // $ target=Supertrait::insert
            self.insert(c2); // $ target=Supertrait::insert
        }
    }

    struct MyType<T>(T);

    impl<T> Supertrait for MyType<T> {
        type Content = T;
        fn insert(&self, _content: Self::Content) {
            println!("Inserting content: ");
        }
    }

    impl<T: Clone> Subtrait for MyType<T> {
        // MyType::get_content
        fn get_content(&self) -> Self::Content {
            (*self).0.clone() // $ fieldof=MyType target=clone target=deref
        }
    }

    fn get_content<T: Subtrait>(item: &T) -> T::Content {
        item.get_content() // $ target=Subtrait::get_content
    }

    fn insert_three<T: Subtrait2>(item: &T, c1: T::Content, c2: T::Content, c3: T::Content) {
        item.insert(c1); // $ target=Supertrait::insert
        item.insert_two(c2, c3); // $ target=Subtrait2::insert_two
    }

    fn test() {
        let item1 = MyType(42i64);
        let _content1 = item1.get_content(); // $ target=MyType::get_content MISSING: type=_content1:i64

        let item2 = MyType(true);
        let _content2 = get_content(&item2); // $ target=get_content MISSING: type=_content2:bool
    }
}

mod generic_enum {
    #[derive(Debug)]
    enum MyEnum<A> {
        C1(A),
        C2 { a: A },
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    impl<T> MyEnum<T> {
        fn m1(self) -> T {
            match self {
                MyEnum::C1(a) => a,
                MyEnum::C2 { a } => a,
            }
        }
    }

    pub fn f() {
        let x = MyEnum::C1(S1);
        let y = MyEnum::C2 { a: S2 };

        println!("{:?}", x.m1()); // $ target=m1
        println!("{:?}", y.m1()); // $ target=m1
    }
}

mod method_supertraits {
    #[derive(Debug)]
    struct MyThing<A> {
        a: A,
    }

    #[derive(Debug)]
    struct MyThing2<A> {
        a: A,
    }

    #[derive(Debug)]
    struct S1;
    #[derive(Debug)]
    struct S2;

    trait MyTrait1<Tr1> {
        // MyTrait1::m1
        fn m1(self) -> Tr1;
    }

    trait MyTrait2<Tr2>: MyTrait1<Tr2> {
        #[rustfmt::skip]
        fn m2(self) -> Tr2
        where
            Self: Sized,
        {
            if 3 > 2 { // $ target=gt
                self.m1() // $ target=MyTrait1::m1
            } else {
                Self::m1(self) // $ target=MyTrait1::m1
            }
        }
    }

    trait MyTrait3<Tr3>: MyTrait2<MyThing<Tr3>> {
        #[rustfmt::skip]
        fn m3(self) -> Tr3
        where
            Self: Sized,
        {
            if 3 > 2 { // $ target=gt
                self.m2().a // $ target=m2 $ fieldof=MyThing
            } else {
                Self::m2(self).a // $ target=m2 fieldof=MyThing
            }
        }
    }

    impl<T> MyTrait1<T> for MyThing<T> {
        // MyThing::m1
        fn m1(self) -> T {
            self.a // $ fieldof=MyThing
        }
    }

    impl<T> MyTrait2<T> for MyThing<T> {}

    impl<T> MyTrait1<MyThing<T>> for MyThing2<T> {
        // MyThing2::m1
        fn m1(self) -> MyThing<T> {
            MyThing { a: self.a } // $ fieldof=MyThing2
        }
    }

    impl<T> MyTrait2<MyThing<T>> for MyThing2<T> {}

    impl<T> MyTrait3<T> for MyThing2<T> {}

    fn call_trait_m1<T1, T2: MyTrait1<T1>>(x: T2) -> T1 {
        x.m1() // $ target=MyTrait1::m1
    }

    fn type_param_trait_to_supertrait<T: MyTrait3<S1>>(x: T) {
        // Test that `MyTrait3` is a subtrait of `MyTrait1<MyThing<S1>>`
        let a = x.m1(); // $ target=MyTrait1::m1 type=a:MyThing type=a:A.S1
        println!("{:?}", a);
    }

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1()); // $ target=MyThing::m1
        println!("{:?}", y.m1()); // $ target=MyThing::m1

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2()); // $ target=m2 type=x.m2():S1
        println!("{:?}", y.m2()); // $ target=m2 type=y.m2():S2

        let x = MyThing2 { a: S1 };
        let y = MyThing2 { a: S2 };

        println!("{:?}", x.m3()); // $ target=m3 type=x.m3():S1
        println!("{:?}", y.m3()); // $ target=m3 type=y.m3():S2

        let x = MyThing { a: S1 };
        let s = call_trait_m1(x); // $ type=s:S1 target=call_trait_m1

        let x = MyThing2 { a: S2 };
        let s = call_trait_m1(x); // $ type=s:MyThing type=s:A.S2 target=call_trait_m1
    }
}

mod function_trait_bounds_2 {
    use std::fmt::Debug;

    #[derive(Debug)]
    struct S1;

    #[derive(Debug)]
    struct S2;

    trait Trait: Debug {}

    impl Trait for S1 {}

    fn id<T: ?Sized>(x: &T) -> &T {
        x
    }

    impl Into<S2> for S1 {
        fn into(self) -> S2 {
            S2
        }
    }

    fn into<T1, T2>(x: T1) -> T2
    where
        T1: Into<T2>,
    {
        x.into() // $ target=into
    }

    pub fn f() {
        let x = S1;
        println!("{:?}", id(&x)); // $ target=id

        let x = S1;
        println!("{:?}", id::<S1>(&x)); // $ target=id

        let x = S1;
        // incorrectly has type `S1` instead of `Trait`
        println!("{:?}", id::<dyn Trait>(&x)); // $ target=id

        let x = S1;
        into::<S1, S2>(x); // $ target=into

        let x = S1;
        let y: S2 = into(x); // $ target=into
    }
}

mod type_aliases {
    #[derive(Debug)]
    enum PairOption<Fst, Snd> {
        PairNone(),
        PairFst(Fst),
        PairSnd(Snd),
        PairBoth(Fst, Snd),
    }

    impl<Fst, Snd> PairOption<Fst, Snd> {
        fn unwrapSnd(self) -> Snd {
            match self {
                PairOption::PairNone() => panic!("PairNone has no second element"),
                PairOption::PairFst(_) => panic!("PairFst has no second element"),
                PairOption::PairSnd(snd) => snd,
                PairOption::PairBoth(_, snd) => snd,
            }
        }
    }

    #[derive(Debug)]
    struct S1;

    #[derive(Debug)]
    struct S2;

    #[derive(Debug)]
    struct S3;

    // Non-generic type alias that fully applies the generic type
    type MyPair = PairOption<S1, S2>;

    // Generic type alias that partially applies the generic type
    type AnotherPair<A3> = PairOption<S2, A3>;

    // Alias to another alias
    type AliasToAlias<A4> = AnotherPair<A4>;

    // Alias that appears nested within another alias
    type NestedAlias<A5> = AnotherPair<AliasToAlias<A5>>;

    fn g(t: NestedAlias<S3>) {
        let x = t.unwrapSnd().unwrapSnd(); // $ target=unwrapSnd type=x:S3
        println!("{:?}", x);
    }

    struct S4<T41, T42>(T41, T42);

    struct S5<T5>(T5);

    type S6<T6> = S4<T6, S5<T6>>;

    type S7<T7> = Result<S6<T7>, S1>;

    struct GenS<GenT>(GenT);

    trait TraitWithAssocType {
        type Output;
        fn get_input(self) -> Self::Output;
    }

    impl<Output> TraitWithAssocType for GenS<Output> {
        // This is not a recursive type, the `Output` on the right-hand side
        // refers to the type parameter of the impl block just above.
        type Output = Result<Output, Output>;

        fn get_input(self) -> Self::Output {
            Ok(self.0) // $ fieldof=GenS type=Ok(...):Result type=Ok(...):T.Output type=Ok(...):E.Output
        }
    }

    pub fn f() {
        // Type can be inferred from the constructor
        let p1: MyPair = PairOption::PairBoth(S1, S2);
        println!("{:?}", p1);

        // Type can be only inferred from the type alias
        let p2: MyPair = PairOption::PairNone(); // $ type=p2:Fst.S1 type=p2:Snd.S2
        println!("{:?}", p2);

        // First type from alias, second from constructor
        let p3: AnotherPair<_> = PairOption::PairSnd(S3); // $ type=p3:Fst.S2
        println!("{:?}", p3);

        // First type from alias definition, second from argument to alias
        let p3: AnotherPair<S3> = PairOption::PairNone(); // $ type=p3:Fst.S2 type=p3:Snd.S3
        println!("{:?}", p3);

        g(PairOption::PairSnd(PairOption::PairSnd(S3))); // $ target=g

        let x: S7<S2>; // $ type=x:Result $ type=x:E.S1 $ type=x:T.S4 $ type=x:T.T41.S2 $ type=x:T.T42.S5 $ type=x:T.T42.T5.S2

        let y = GenS(true).get_input(); // $ type=y:Result type=y:T.bool type=y:E.bool target=get_input
    }
}

mod option_methods {
    #[derive(Debug)]
    enum MyOption<T> {
        MyNone(),
        MySome(T),
    }

    trait MyTrait<S> {
        // MyTrait::set
        fn set(&mut self, value: S);

        fn call_set(&mut self, value: S) {
            self.set(value); // $ target=MyTrait::set
        }
    }

    impl<T> MyTrait<T> for MyOption<T> {
        // MyOption::set
        fn set(&mut self, value: T) {}
    }

    impl<T> MyOption<T> {
        fn new() -> Self {
            MyOption::MyNone()
        }
    }

    impl<T> MyOption<MyOption<T>> {
        fn flatten(self) -> MyOption<T> {
            match self {
                MyOption::MyNone() => MyOption::MyNone(),
                MyOption::MySome(x) => x,
            }
        }
    }

    #[derive(Debug)]
    struct S;

    pub fn f() {
        let x1 = MyOption::<S>::new(); // $ type=x1:T.S target=new
        println!("{:?}", x1);

        let mut x2 = MyOption::new(); // $ target=new
        x2.set(S); // $ target=MyOption::set
        println!("{:?}", x2);

        // missing type `S` from `MyOption<S>` (but can resolve `MyTrait<S>`)
        let mut x3 = MyOption::new(); // $ target=new
        x3.call_set(S); // $ target=call_set
        println!("{:?}", x3);

        let mut x4 = MyOption::new(); // $ target=new
        MyOption::set(&mut x4, S); // $ target=MyOption::set
        println!("{:?}", x4);

        let x5 = MyOption::MySome(MyOption::<S>::MyNone());
        println!("{:?}", x5.flatten()); // $ target=flatten

        let x6 = MyOption::MySome(MyOption::<S>::MyNone());
        println!("{:?}", MyOption::<MyOption<S>>::flatten(x6)); // $ target=flatten

        #[rustfmt::skip]
        let from_if = if 3 > 2 { // $ target=gt
            MyOption::MyNone()
        } else {
            MyOption::MySome(S)
        };
        println!("{:?}", from_if);

        #[rustfmt::skip]
        let from_match = match 3 > 2 { // $ target=gt
            true => MyOption::MyNone(),
            false => MyOption::MySome(S),
        };
        println!("{:?}", from_match);

        #[rustfmt::skip]
        let from_loop = loop {
            if 3 > 2 { // $ target=gt
                break MyOption::MyNone();
            }
            break MyOption::MySome(S);
        };
        println!("{:?}", from_loop);
    }
}

mod method_call_type_conversion {

    #[derive(Debug, Copy, Clone)]
    struct S<T>(T);

    #[derive(Debug, Copy, Clone)]
    struct S2;

    #[derive(Debug, Copy, Clone, Default)]
    struct MyInt {
        a: i64,
    }

    impl<T> S<T> {
        fn m1(self) -> T {
            self.0 // $ fieldof=S
        }

        fn m2(&self) -> &T {
            &self.0 // $ fieldof=S
        }

        fn m3(self: &S<T>) -> &T {
            &self.0 // $ fieldof=S
        }
    }

    trait ATrait {
        fn method_on_borrow(&self) -> i64;
        fn method_not_on_borrow(self) -> i64;
    }

    // Trait implementation on a borrow.
    impl ATrait for &MyInt {
        // MyInt::method_on_borrow
        fn method_on_borrow(&self) -> i64 {
            (*(*self)).a // $ target=deref fieldof=MyInt
        }

        // MyInt::method_not_on_borrow
        fn method_not_on_borrow(self) -> i64 {
            (*self).a // $ target=deref fieldof=MyInt
        }
    }

    pub fn f() {
        let x1 = S(S2);
        println!("{:?}", x1.m1()); // $ target=m1

        let x2 = S(S2);
        // implicit borrow
        println!("{:?}", x2.m2()); // $ target=m2
        println!("{:?}", x2.m3()); // $ target=m3

        let x3 = S(S2);
        // explicit borrow
        println!("{:?}", S::<S2>::m2(&x3)); // $ target=m2
        println!("{:?}", S::<S2>::m3(&x3)); // $ target=m3

        let x4 = &S(S2);
        // explicit borrow
        println!("{:?}", x4.m2()); // $ target=m2
        println!("{:?}", x4.m3()); // $ target=m3

        let x5 = &S(S2);
        // implicit dereference
        println!("{:?}", x5.m1()); // $ target=m1
        println!("{:?}", x5.0); // $ fieldof=S

        let x6 = &S(S2);

        // explicit dereference
        println!("{:?}", (*x6).m1()); // $ target=m1 target=deref

        let x7 = S(&S2);
        // Non-implicit dereference with nested borrow in order to test that the
        // implicit dereference handling doesn't affect nested borrows.
        let t = x7.m1(); // $ target=m1 type=t:& type=t:&T.S2
        println!("{:?}", x7);

        let x9: String = "Hello".to_string(); // $ type=x9:String

        // Implicit `String` -> `str` conversion happens via the `Deref` trait:
        // https://doc.rust-lang.org/std/string/struct.String.html#deref.
        let u = x9.parse::<u32>(); // $ target=parse type=u:T.u32

        let my_thing = &MyInt { a: 37 };
        // implicit borrow of a `&`
        let a = my_thing.method_on_borrow(); // $ MISSING: target=MyInt::method_on_borrow
        println!("{:?}", a);

        // no implicit borrow
        let my_thing = &MyInt { a: 38 };
        let a = my_thing.method_not_on_borrow(); // $ MISSING: target=MyInt::method_not_on_borrow
        println!("{:?}", a);
    }
}

mod trait_implicit_self_borrow {
    trait MyTrait {
        // MyTrait::foo
        fn foo(&self) -> &Self;

        // MyTrait::bar
        fn bar(&self) -> &Self {
            self.foo() // $ target=MyTrait::foo
        }
    }

    struct MyStruct;

    impl MyTrait for MyStruct {
        // MyStruct::foo
        fn foo(&self) -> &MyStruct {
            self
        }
    }

    pub fn f() {
        let x = MyStruct;
        x.bar(); // $ target=MyTrait::bar
    }
}

mod implicit_self_borrow {
    struct S;

    struct MyStruct<T>(T);

    impl<T> MyStruct<T> {
        fn foo(&self) -> &Self {
            self
        }
    }

    pub fn f() {
        let x = MyStruct(S);
        x.foo(); // $ target=foo
    }
}

mod borrowed_typed {
    #[derive(Debug, Copy, Clone, Default)]
    struct MyFlag {
        bool: bool,
    }

    impl MyFlag {
        fn flip(&mut self) {
            self.bool = !self.bool; // $ fieldof=MyFlag target=not
        }
    }

    struct S;

    impl S {
        fn f1(&self) -> &Self {
            &&&self
        }

        fn f2(self: &Self) -> &Self {
            &&&self
        }

        fn f3(x: &Self) -> &Self {
            x
        }

        fn f4(x: &Self) -> &Self {
            &&&x
        }
    }

    pub fn f() {
        let x = S {};
        x.f1(); // $ target=f1
        x.f2(); // $ target=f2
        S::f3(&x); // $ target=f3

        let n = **&&true; // $ type=n:bool target=deref

        // In this example the type of `flag` must be inferred at the call to
        // `flip` and flow through the borrow in the argument.
        let mut flag = Default::default(); // $ target=default
        MyFlag::flip(&mut flag); // $ target=flip
        println!("{:?}", flag); // $ type=flag:MyFlag
    }
}

mod try_expressions {
    use std::fmt::Debug;

    #[derive(Debug)]
    struct S1;

    #[derive(Debug)]
    struct S2;

    // Simple function using ? operator with same error types

    fn try_same_error() -> Result<S1, S1> {
        let x = Result::Ok(S1)?; // $ type=x:S1
        Result::Ok(S1)
    }

    // Function using ? operator with different error types that need conversion

    fn try_convert_error() -> Result<S1, S2> {
        let x = Result::Ok(S1);
        let y = x?; // $ type=y:S1
        Result::Ok(S1)
    }

    // Chained ? operations

    fn try_chained() -> Result<S1, S2> {
        let x = Result::Ok(Result::Ok(S1));
        // First ? returns Result<S1, S2>, second ? returns S1
        let y = x?.map(|s| s)?; // $ target=map
        Result::Ok(S1)
    }

    // Function that uses ? with closures and complex error cases

    fn try_complex<T: Debug>(input: Result<T, S1>) -> Result<T, S1> {
        let value = input?;
        let mapped = Result::Ok(value).and_then(|v| {
            println!("{:?}", v);
            Result::Ok::<_, S1>(v)
        })?; // $ target=and_then
        Result::Err(S1)
    }

    #[rustfmt::skip]
    pub fn f() {
        if let Result::Ok(result) = try_same_error() { // $ target=try_same_error
            println!("{:?}", result);
        }

        if let Result::Ok(result) = try_convert_error() { // $ target=try_convert_error
            println!("{:?}", result);
        }

        if let Result::Ok(result) = try_chained() { // $ target=try_chained
            println!("{:?}", result);
        }

        if let Result::Ok(result) = try_complex(Result::Ok(S1)) { // $ target=try_complex
            println!("{:?}", result);
        }
    }
}

mod builtins {
    pub fn f() {
        let x: i32 = 1; // $ type=x:i32
        let y = 2; // $ type=y:i32
        let z = x + y; // $ type=z:i32 target=add
        let z = x.abs(); // $ target=abs $ type=z:i32
        let c = 'c'; // $ type=c:char
        let hello = "Hello"; // $ type=hello:&T.str
        let f = 123.0f64; // $ type=f:f64
        let t = true; // $ type=t:bool
        let f = false; // $ type=f:bool
    }
}

// Tests for non-overloaded operators.
mod operators {
    pub fn f() {
        let x = true && false; // $ type=x:bool
        let y = true || false; // $ type=y:bool

        let mut a;
        let cond = 34 == 33; // $ target=eq
        if cond {
            let z = (a = 1); // $ type=z:() type=a:i32
        } else {
            a = 2; // $ type=a:i32
        }
        a; // $ type=a:i32
    }
}

// Tests for overloaded operators.
mod overloadable_operators {
    use std::ops::*;
    // A vector type with overloaded operators.
    #[derive(Debug, Copy, Clone)]
    struct Vec2 {
        x: i64,
        y: i64,
    }
    impl Default for Vec2 {
        fn default() -> Self {
            Vec2 { x: 0, y: 0 }
        }
    }
    // Implement all overloadable operators for Vec2
    impl Add for Vec2 {
        type Output = Self;
        // Vec2::add
        fn add(self, rhs: Self) -> Self {
            Vec2 {
                x: self.x + rhs.x, // $ fieldof=Vec2 target=add
                y: self.y + rhs.y, // $ fieldof=Vec2 target=add
            }
        }
    }
    impl AddAssign for Vec2 {
        // Vec2::add_assign
        #[rustfmt::skip]
        fn add_assign(&mut self, rhs: Self) {
            self.x += rhs.x; // $ fieldof=Vec2 target=add_assign
            self.y += rhs.y; // $ fieldof=Vec2 target=add_assign
        }
    }
    impl Sub for Vec2 {
        type Output = Self;
        // Vec2::sub
        fn sub(self, rhs: Self) -> Self {
            Vec2 {
                x: self.x - rhs.x, // $ fieldof=Vec2 target=sub
                y: self.y - rhs.y, // $ fieldof=Vec2 target=sub
            }
        }
    }
    impl SubAssign for Vec2 {
        // Vec2::sub_assign
        #[rustfmt::skip]
        fn sub_assign(&mut self, rhs: Self) {
            self.x -= rhs.x; // $ fieldof=Vec2 target=sub_assign
            self.y -= rhs.y; // $ fieldof=Vec2 target=sub_assign
        }
    }
    impl Mul for Vec2 {
        type Output = Self;
        // Vec2::mul
        fn mul(self, rhs: Self) -> Self {
            Vec2 {
                x: self.x * rhs.x, // $ fieldof=Vec2 target=mul
                y: self.y * rhs.y, // $ fieldof=Vec2 target=mul
            }
        }
    }
    impl MulAssign for Vec2 {
        // Vec2::mul_assign
        fn mul_assign(&mut self, rhs: Self) {
            self.x *= rhs.x; // $ fieldof=Vec2 target=mul_assign
            self.y *= rhs.y; // $ fieldof=Vec2 target=mul_assign
        }
    }
    impl Div for Vec2 {
        type Output = Self;
        // Vec2::div
        fn div(self, rhs: Self) -> Self {
            Vec2 {
                x: self.x / rhs.x, // $ fieldof=Vec2 target=div
                y: self.y / rhs.y, // $ fieldof=Vec2 target=div
            }
        }
    }
    impl DivAssign for Vec2 {
        // Vec2::div_assign
        fn div_assign(&mut self, rhs: Self) {
            self.x /= rhs.x; // $ fieldof=Vec2 target=div_assign
            self.y /= rhs.y; // $ fieldof=Vec2 target=div_assign
        }
    }
    impl Rem for Vec2 {
        type Output = Self;
        // Vec2::rem
        fn rem(self, rhs: Self) -> Self {
            Vec2 {
                x: self.x % rhs.x, // $ fieldof=Vec2 target=rem
                y: self.y % rhs.y, // $ fieldof=Vec2 target=rem
            }
        }
    }
    impl RemAssign for Vec2 {
        // Vec2::rem_assign
        fn rem_assign(&mut self, rhs: Self) {
            self.x %= rhs.x; // $ fieldof=Vec2 target=rem_assign
            self.y %= rhs.y; // $ fieldof=Vec2 target=rem_assign
        }
    }
    impl BitAnd for Vec2 {
        type Output = Self;
        // Vec2::bitand
        fn bitand(self, rhs: Self) -> Self {
            Vec2 {
                x: self.x & rhs.x, // $ fieldof=Vec2 target=bitand
                y: self.y & rhs.y, // $ fieldof=Vec2 target=bitand
            }
        }
    }
    impl BitAndAssign for Vec2 {
        // Vec2::bitand_assign
        fn bitand_assign(&mut self, rhs: Self) {
            self.x &= rhs.x; // $ fieldof=Vec2 target=bitand_assign
            self.y &= rhs.y; // $ fieldof=Vec2 target=bitand_assign
        }
    }
    impl BitOr for Vec2 {
        type Output = Self;
        // Vec2::bitor
        fn bitor(self, rhs: Self) -> Self {
            Vec2 {
                x: self.x | rhs.x, // $ fieldof=Vec2 target=bitor
                y: self.y | rhs.y, // $ fieldof=Vec2 target=bitor
            }
        }
    }
    impl BitOrAssign for Vec2 {
        // Vec2::bitor_assign
        fn bitor_assign(&mut self, rhs: Self) {
            self.x |= rhs.x; // $ fieldof=Vec2 target=bitor_assign
            self.y |= rhs.y; // $ fieldof=Vec2 target=bitor_assign
        }
    }
    impl BitXor for Vec2 {
        type Output = Self;
        // Vec2::bitxor
        fn bitxor(self, rhs: Self) -> Self {
            Vec2 {
                x: self.x ^ rhs.x, // $ fieldof=Vec2 target=bitxor
                y: self.y ^ rhs.y, // $ fieldof=Vec2 target=bitxor
            }
        }
    }
    impl BitXorAssign for Vec2 {
        // Vec2::bitxor_assign
        fn bitxor_assign(&mut self, rhs: Self) {
            self.x ^= rhs.x; // $ fieldof=Vec2 target=bitxor_assign
            self.y ^= rhs.y; // $ fieldof=Vec2 target=bitxor_assign
        }
    }
    impl Shl<u32> for Vec2 {
        type Output = Self;
        // Vec2::shl
        fn shl(self, rhs: u32) -> Self {
            Vec2 {
                x: self.x << rhs, // $ fieldof=Vec2 target=shl
                y: self.y << rhs, // $ fieldof=Vec2 target=shl
            }
        }
    }
    impl ShlAssign<u32> for Vec2 {
        // Vec2::shl_assign
        fn shl_assign(&mut self, rhs: u32) {
            self.x <<= rhs; // $ fieldof=Vec2 target=shl_assign
            self.y <<= rhs; // $ fieldof=Vec2 target=shl_assign
        }
    }
    impl Shr<u32> for Vec2 {
        type Output = Self;
        // Vec2::shr
        fn shr(self, rhs: u32) -> Self {
            Vec2 {
                x: self.x >> rhs, // $ fieldof=Vec2 target=shr
                y: self.y >> rhs, // $ fieldof=Vec2 target=shr
            }
        }
    }
    impl ShrAssign<u32> for Vec2 {
        // Vec2::shr_assign
        fn shr_assign(&mut self, rhs: u32) {
            self.x >>= rhs; // $ fieldof=Vec2 target=shr_assign
            self.y >>= rhs; // $ fieldof=Vec2 target=shr_assign
        }
    }
    impl Neg for Vec2 {
        type Output = Self;
        // Vec2::neg
        fn neg(self) -> Self {
            Vec2 {
                x: -self.x, // $ fieldof=Vec2 target=neg
                y: -self.y, // $ fieldof=Vec2 target=neg
            }
        }
    }
    impl Not for Vec2 {
        type Output = Self;
        // Vec2::not
        fn not(self) -> Self {
            Vec2 {
                x: !self.x, // $ fieldof=Vec2 target=not
                y: !self.y, // $ fieldof=Vec2 target=not
            }
        }
    }
    impl PartialEq for Vec2 {
        // Vec2::eq
        fn eq(&self, other: &Self) -> bool {
            self.x == other.x && self.y == other.y // $ fieldof=Vec2 target=eq
        }
        // Vec2::ne
        fn ne(&self, other: &Self) -> bool {
            self.x != other.x || self.y != other.y // $ fieldof=Vec2 target=ne
        }
    }
    impl PartialOrd for Vec2 {
        // Vec2::partial_cmp
        fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
            (self.x + self.y).partial_cmp(&(other.x + other.y)) // $ fieldof=Vec2 target=partial_cmp target=add
        }
        // Vec2::lt
        fn lt(&self, other: &Self) -> bool {
            self.x < other.x && self.y < other.y // $ fieldof=Vec2 target=lt
        }
        // Vec2::le
        fn le(&self, other: &Self) -> bool {
            self.x <= other.x && self.y <= other.y // $ fieldof=Vec2 target=le
        }
        // Vec2::gt
        fn gt(&self, other: &Self) -> bool {
            self.x > other.x && self.y > other.y // $ fieldof=Vec2 target=gt
        }
        // Vec2::ge
        fn ge(&self, other: &Self) -> bool {
            self.x >= other.x && self.y >= other.y // $ fieldof=Vec2 target=ge
        }
    }
    pub fn f() {
        // Test for all overloadable operators on `i64`

        // Comparison operators
        let i64_eq = (1i64 == 2i64); // $ type=i64_eq:bool target=eq
        let i64_ne = (3i64 != 4i64); // $ type=i64_ne:bool target=ne
        let i64_lt = (5i64 < 6i64); // $ type=i64_lt:bool target=lt
        let i64_le = (7i64 <= 8i64); // $ type=i64_le:bool target=le
        let i64_gt = (9i64 > 10i64); // $ type=i64_gt:bool target=gt
        let i64_ge = (11i64 >= 12i64); // $ type=i64_ge:bool target=ge

        // Arithmetic operators
        let i64_add = 13i64 + 14i64; // $ type=i64_add:i64 target=add
        let i64_sub = 15i64 - 16i64; // $ type=i64_sub:i64 target=sub
        let i64_mul = 17i64 * 18i64; // $ type=i64_mul:i64 target=mul
        let i64_div = 19i64 / 20i64; // $ type=i64_div:i64 target=div
        let i64_rem = 21i64 % 22i64; // $ type=i64_rem:i64 target=rem

        // Arithmetic assignment operators
        let mut i64_add_assign = 23i64;
        i64_add_assign += 24i64; // $ target=add_assign

        let mut i64_sub_assign = 25i64;
        i64_sub_assign -= 26i64; // $ target=sub_assign

        let mut i64_mul_assign = 27i64;
        i64_mul_assign *= 28i64; // $ target=mul_assign

        let mut i64_div_assign = 29i64;
        i64_div_assign /= 30i64; // $ target=div_assign

        let mut i64_rem_assign = 31i64;
        i64_rem_assign %= 32i64; // $ target=rem_assign

        // Bitwise operators
        let i64_bitand = 33i64 & 34i64; // $ type=i64_bitand:i64 target=bitand
        let i64_bitor = 35i64 | 36i64; // $ type=i64_bitor:i64 target=bitor
        let i64_bitxor = 37i64 ^ 38i64; // $ type=i64_bitxor:i64 target=bitxor
        let i64_shl = 39i64 << 40i64; // $ type=i64_shl:i64 target=shl
        let i64_shr = 41i64 >> 42i64; // $ type=i64_shr:i64 target=shr

        // Bitwise assignment operators
        let mut i64_bitand_assign = 43i64;
        i64_bitand_assign &= 44i64; // $ target=bitand_assign

        let mut i64_bitor_assign = 45i64;
        i64_bitor_assign |= 46i64; // $ target=bitor_assign

        let mut i64_bitxor_assign = 47i64;
        i64_bitxor_assign ^= 48i64; // $ target=bitxor_assign

        let mut i64_shl_assign = 49i64;
        i64_shl_assign <<= 50i64; // $ target=shl_assign

        let mut i64_shr_assign = 51i64;
        i64_shr_assign >>= 52i64; // $ target=shr_assign

        let i64_neg = -53i64; // $ type=i64_neg:i64 target=neg
        let i64_not = !54i64; // $ type=i64_not:i64 target=not

        // Test for all overloadable operators on Vec2
        let v1 = Vec2 { x: 1, y: 2 };
        let v2 = Vec2 { x: 3, y: 4 };

        // Comparison operators
        let vec2_eq = v1 == v2; // $ type=vec2_eq:bool target=Vec2::eq
        let vec2_ne = v1 != v2; // $ type=vec2_ne:bool target=Vec2::ne
        let vec2_lt = v1 < v2; // $ type=vec2_lt:bool target=Vec2::lt
        let vec2_le = v1 <= v2; // $ type=vec2_le:bool target=Vec2::le
        let vec2_gt = v1 > v2; // $ type=vec2_gt:bool target=Vec2::gt
        let vec2_ge = v1 >= v2; // $ type=vec2_ge:bool target=Vec2::ge

        // Arithmetic operators
        let vec2_add = v1 + v2; // $ type=vec2_add:Vec2 target=Vec2::add
        let vec2_sub = v1 - v2; // $ type=vec2_sub:Vec2 target=Vec2::sub
        let vec2_mul = v1 * v2; // $ type=vec2_mul:Vec2 target=Vec2::mul
        let vec2_div = v1 / v2; // $ type=vec2_div:Vec2 target=Vec2::div
        let vec2_rem = v1 % v2; // $ type=vec2_rem:Vec2 target=Vec2::rem

        // Arithmetic assignment operators
        let mut vec2_add_assign = v1;
        vec2_add_assign += v2; // $ target=Vec2::add_assign

        let mut vec2_sub_assign = v1;
        vec2_sub_assign -= v2; // $ target=Vec2::sub_assign

        let mut vec2_mul_assign = v1;
        vec2_mul_assign *= v2; // $ target=Vec2::mul_assign

        let mut vec2_div_assign = v1;
        vec2_div_assign /= v2; // $ target=Vec2::div_assign

        let mut vec2_rem_assign = v1;
        vec2_rem_assign %= v2; // $ target=Vec2::rem_assign

        // Bitwise operators
        let vec2_bitand = v1 & v2; // $ type=vec2_bitand:Vec2 target=Vec2::bitand
        let vec2_bitor = v1 | v2; // $ type=vec2_bitor:Vec2 target=Vec2::bitor
        let vec2_bitxor = v1 ^ v2; // $ type=vec2_bitxor:Vec2 target=Vec2::bitxor
        let vec2_shl = v1 << 1u32; // $ type=vec2_shl:Vec2 target=Vec2::shl
        let vec2_shr = v1 >> 1u32; // $ type=vec2_shr:Vec2 target=Vec2::shr

        // Bitwise assignment operators
        let mut vec2_bitand_assign = v1;
        vec2_bitand_assign &= v2; // $ target=Vec2::bitand_assign

        let mut vec2_bitor_assign = v1;
        vec2_bitor_assign |= v2; // $ target=Vec2::bitor_assign

        let mut vec2_bitxor_assign = v1;
        vec2_bitxor_assign ^= v2; // $ target=Vec2::bitxor_assign

        let mut vec2_shl_assign = v1;
        vec2_shl_assign <<= 1u32; // $ target=Vec2::shl_assign

        let mut vec2_shr_assign = v1;
        vec2_shr_assign >>= 1u32; // $ target=Vec2::shr_assign

        // Prefix operators
        let vec2_neg = -v1; // $ type=vec2_neg:Vec2 target=Vec2::neg
        let vec2_not = !v1; // $ type=vec2_not:Vec2 target=Vec2::not

        // Here the type of `default_vec2` must be inferred from the `+` call.
        let default_vec2 = Default::default(); // $ type=default_vec2:Vec2 target=default
        let vec2_zero_plus = Vec2 { x: 0, y: 0 } + default_vec2; // $ target=Vec2::add

        // Here the type of `default_vec2` must be inferred from the `==` call
        // and the type of the borrowed second argument is unknown at the call.
        let default_vec2 = Default::default(); // $ type=default_vec2:Vec2 target=default
        let vec2_zero_plus = Vec2 { x: 0, y: 0 } == default_vec2; // $ target=Vec2::eq
    }
}

mod async_ {
    use std::future::Future;

    struct S1;

    impl S1 {
        pub fn f(self) {} // S1f
    }

    async fn f1() -> S1 {
        S1
    }

    fn f2() -> impl Future<Output = S1> {
        async { S1 }
    }

    struct S2;

    impl Future for S2 {
        type Output = S1;

        fn poll(
            self: std::pin::Pin<&mut Self>,
            _cx: &mut std::task::Context<'_>,
        ) -> std::task::Poll<Self::Output> {
            std::task::Poll::Ready(S1)
        }
    }

    fn f3() -> impl Future<Output = S1> {
        S2
    }

    pub async fn f() {
        f1().await.f(); // $ target=S1f target=f1
        f2().await.f(); // $ target=S1f target=f2
        f3().await.f(); // $ target=S1f target=f3
        S2.await.f(); // $ target=S1f
        let b = async { S1 };
        b.await.f(); // $ target=S1f
    }
}

mod impl_trait {
    #[derive(Copy, Clone)]
    struct S1;
    struct S2;
    struct S3<T3>(T3);

    trait Trait1 {
        fn f1(&self) {} // Trait1f1
    }

    trait Trait2 {
        fn f2(&self) {} // Trait2f2
    }

    impl Trait1 for S1 {
        fn f1(&self) {} // S1f1
    }

    impl Trait2 for S1 {
        fn f2(&self) {} // S1f2
    }

    fn f1() -> impl Trait1 + Trait2 {
        S1
    }

    trait MyTrait<A> {
        fn get_a(&self) -> A; // MyTrait::get_a
    }

    impl MyTrait<S2> for S1 {
        fn get_a(&self) -> S2 {
            S2
        }
    }

    impl<T: Clone> MyTrait<T> for S3<T> {
        fn get_a(&self) -> T {
            let S3(t) = self;
            t.clone()
        }
    }

    fn get_a_my_trait() -> impl MyTrait<S2> {
        S1
    }

    fn uses_my_trait1<A, B: MyTrait<A>>(t: B) -> A {
        t.get_a() // $ target=MyTrait::get_a
    }

    fn get_a_my_trait2<T: Clone>(x: T) -> impl MyTrait<T> {
        S3(x)
    }

    fn get_a_my_trait3<T: Clone>(x: T) -> Option<impl MyTrait<T>> {
        Some(S3(x))
    }

    fn get_a_my_trait4<T: Clone>(x: T) -> (impl MyTrait<T>, impl MyTrait<T>) {
        (S3(x.clone()), S3(x)) // $ target=clone
    }

    fn uses_my_trait2<A>(t: impl MyTrait<A>) -> A {
        t.get_a() // $ target=MyTrait::get_a
    }

    pub fn f() {
        let x = f1(); // $ target=f1
        x.f1(); // $ target=Trait1f1
        x.f2(); // $ target=Trait2f2
        let a = get_a_my_trait(); // $ target=get_a_my_trait
        let b = uses_my_trait1(a); // $ type=b:S2 target=uses_my_trait1
        let a = get_a_my_trait(); // $ target=get_a_my_trait
        let c = uses_my_trait2(a); // $ type=c:S2 target=uses_my_trait2
        let d = uses_my_trait2(S1); // $ type=d:S2 target=uses_my_trait2
        let e = get_a_my_trait2(S1).get_a(); // $ target=get_a_my_trait2 target=MyTrait::get_a type=e:S1

        // For this function the `impl` type does not appear in the root of the return type
        let f = get_a_my_trait3(S1).unwrap().get_a(); // $ target=get_a_my_trait3 target=unwrap target=MyTrait::get_a type=f:S1
        let g = get_a_my_trait4(S1).0.get_a(); // $ target=get_a_my_trait4 target=MyTrait::get_a type=g:S1
    }
}

mod indexers {
    use std::ops::Index;

    #[derive(Debug)]
    struct S;

    impl S {
        fn foo(&self) -> Self {
            S
        }
    }

    #[derive(Debug)]
    struct MyVec<T> {
        data: Vec<T>,
    }

    impl<T> MyVec<T> {
        fn new() -> Self {
            MyVec { data: Vec::new() } // $ target=new
        }

        fn push(&mut self, value: T) {
            self.data.push(value); // $ fieldof=MyVec target=push
        }
    }

    impl<T> Index<usize> for MyVec<T> {
        type Output = T;

        // MyVec::index
        fn index(&self, index: usize) -> &Self::Output {
            &self.data[index] // $ fieldof=MyVec target=index
        }
    }

    fn analyze_slice(slice: &[S]) {
        let x = slice[0].foo(); // $ target=foo type=x:S target=index
    }

    pub fn f() {
        let mut vec = MyVec::new(); // $ type=vec:T.S target=new
        vec.push(S); // $ target=push
        vec[0].foo(); // $ target=MyVec::index target=foo

        let xs: [S; 1] = [S];
        let x = xs[0].foo(); // $ target=foo type=x:S target=index

        analyze_slice(&xs); // $ target=analyze_slice
    }
}

mod macros {
    pub fn f() {
        let x = format!("Hello, {}", "World!"); // $ type=x:String
    }
}

mod method_determined_by_argument_type {
    trait MyAdd<Rhs = Self> {
        type Output;

        // MyAdd::my_add
        fn my_add(self, rhs: Rhs) -> Self::Output;
    }

    impl MyAdd<i64> for i64 {
        type Output = i64;

        // MyAdd<i64>::my_add
        fn my_add(self, value: i64) -> Self {
            value
        }
    }

    impl MyAdd<&i64> for i64 {
        type Output = i64;

        // MyAdd<&i64>::my_add
        fn my_add(self, value: &i64) -> Self {
            *value // $ target=deref
        }
    }

    impl MyAdd<bool> for i64 {
        type Output = i64;

        // MyAdd<bool>::my_add
        fn my_add(self, value: bool) -> Self {
            if value {
                1
            } else {
                0
            }
        }
    }

    struct S<T>(T);

    impl<T: MyAdd> MyAdd for S<T> {
        type Output = S<T::Output>;

        // S::my_add1
        fn my_add(self, other: Self) -> Self::Output {
            S((self.0).my_add(other.0)) // $ target=MyAdd::my_add $ fieldof=S
        }
    }

    impl<T: MyAdd> MyAdd<T> for S<T> {
        type Output = S<T::Output>;

        // S::my_add2
        fn my_add(self, other: T) -> Self::Output {
            S((self.0).my_add(other)) // $ target=MyAdd::my_add $ fieldof=S
        }
    }

    impl<'a, T> MyAdd<&'a T> for S<T>
    where
        T: MyAdd<&'a T>,
    {
        type Output = S<<T as MyAdd<&'a T>>::Output>;

        // S::my_add3
        fn my_add(self, other: &'a T) -> Self::Output {
            S((self.0).my_add(other)) // $ target=MyAdd::my_add $ fieldof=S
        }
    }

    trait MyFrom<T> {
        // MyFrom::my_from
        fn my_from(value: T) -> Self;
    }

    impl MyFrom<i64> for i64 {
        // MyFrom<i64>::my_from
        fn my_from(value: i64) -> Self {
            value
        }
    }

    impl MyFrom<bool> for i64 {
        // MyFrom<bool>::my_from
        fn my_from(value: bool) -> Self {
            if value {
                1
            } else {
                0
            }
        }
    }

    trait MyFrom2<T> {
        // MyFrom2::my_from2
        fn my_from2(value: T, x: Self) -> ();
    }

    impl MyFrom2<i64> for i64 {
        // MyFrom2<i64>::my_from2
        fn my_from2(value: i64, _: Self) -> () {
            value;
        }
    }

    impl MyFrom2<bool> for i64 {
        // MyFrom2<bool>::my_from2
        fn my_from2(value: bool, _: Self) -> () {
            if value {
                1
            } else {
                0
            };
        }
    }

    trait MySelfTrait {
        // MySelfTrait::f1
        fn f1(x: Self) -> i64;

        // MySelfTrait::f2
        fn f2(x: Self) -> Self;
    }

    impl MySelfTrait for i64 {
        // MySelfTrait<i64>::f1
        fn f1(x: Self) -> i64 {
            x + 1
        }

        // MySelfTrait<i64>::f2
        fn f2(x: Self) -> Self {
            x + 1
        }
    }

    impl MySelfTrait for bool {
        // MySelfTrait<bool>::f1
        fn f1(x: Self) -> i64 {
            0
        }

        // MySelfTrait<bool>::f2
        fn f2(x: Self) -> Self {
            x
        }
    }

    pub fn f() {
        let x: i64 = 73;
        x.my_add(5i64); // $ target=MyAdd<i64>::my_add
        x.my_add(&5i64); // $ target=MyAdd<&i64>::my_add
        x.my_add(true); // $ target=MyAdd<bool>::my_add

        S(1i64).my_add(S(2i64)); // $ target=S::my_add1
        S(1i64).my_add(3i64); // $ MISSING: target=S::my_add2
        S(1i64).my_add(&3i64); // $ target=S::my_add3

        let x = i64::my_from(73i64); // $ target=MyFrom<i64>::my_from
        let y = i64::my_from(true); // $ target=MyFrom<bool>::my_from
        let z: i64 = MyFrom::my_from(73i64); // $ target=MyFrom<i64>::my_from
        i64::my_from2(73i64, 0i64); // $ target=MyFrom2<i64>::my_from2
        i64::my_from2(true, 0i64); // $ target=MyFrom2<bool>::my_from2
        MyFrom2::my_from2(73i64, 0i64); // $ target=MyFrom2<i64>::my_from2

        i64::f1(73i64); // $ target=MySelfTrait<i64>::f1
        i64::f2(73i64); // $ target=MySelfTrait<i64>::f2
        bool::f1(true); // $ target=MySelfTrait<bool>::f1
        bool::f2(true); // $ target=MySelfTrait<bool>::f2
        MySelfTrait::f1(73i64); // $ target=MySelfTrait<i64>::f1
        MySelfTrait::f2(73i64); // $ target=MySelfTrait<i64>::f2
        MySelfTrait::f1(true); // $ target=MySelfTrait<bool>::f1
        MySelfTrait::f2(true); // $ target=MySelfTrait<bool>::f2
    }
}

mod loops {
    struct MyCallable {}

    impl MyCallable {
        fn new() -> Self {
            MyCallable {}
        }

        fn call(&self) -> i64 {
            1
        }
    }

    pub fn f() {
        // for loops with arrays

        for i in [1, 2, 3] {} // $ type=i:i32
        for i in [1, 2, 3].map(|x| x + 1) {} // $ target=map MISSING: type=i:i32
        for i in [1, 2, 3].into_iter() {} // $ target=into_iter type=i:i32

        let vals1 = [1u8, 2, 3]; // $ type=vals1:[T;...].u8
        for u in vals1 {} // $ type=u:u8

        let vals2 = [1u16; 3]; // $ type=vals2:[T;...].u16
        for u in vals2 {} // $ type=u:u16

        let vals3: [u32; 3] = [1, 2, 3]; // $ type=vals3:[T;...].u32
        for u in vals3 {} // $ type=u:u32

        let vals4: [u64; 3] = [1; 3]; // $ type=vals4:[T;...].u64
        for u in vals4 {} // $ type=u:u64

        let mut strings1 = ["foo", "bar", "baz"]; // $ type=strings1:[T;...].&T.str
        for s in &strings1 {} // $ type=s:&T.&T.str
        for s in &mut strings1 {} // $ type=s:&T.&T.str
        for s in strings1 {} // $ type=s:&T.str

        let strings2 = // $ type=strings2:[T;...].String
        [
            String::from("foo"), // $ target=from
            String::from("bar"), // $ target=from
            String::from("baz"), // $ target=from
        ];
        for s in strings2 {} // $ type=s:String

        let strings3 = // $ type=strings3:&T.[T;...].String
        &[
            String::from("foo"), // $ target=from
            String::from("bar"), // $ target=from
            String::from("baz"), // $ target=from
        ];
        for s in strings3 {} // $ MISSING: type=s:String

        let callables = [MyCallable::new(), MyCallable::new(), MyCallable::new()]; // $ target=new $ MISSING: type=callables:[T;...].MyCallable; 3
        for c // $ type=c:MyCallable
        in callables
        {
            let result = c.call(); // $ type=result:i64 target=call
        }

        // for loops with ranges

        for i in 0..10 {} // $ type=i:i32
        for u in [0u8..10] {} // $ type=u:Range type=u:Idx.u8
        let range = 0..10; // $ type=range:Range type=range:Idx.i32
        for i in range {} // $ type=i:i32

        let range1 = // $ type=range1:Range type=range1:Idx.u16
        std::ops::Range {
            start: 0u16,
            end: 10u16,
        };
        for u in range1 {} // $ type=u:u16

        // for loops with containers

        let vals3 = vec![1, 2, 3]; // $ MISSING: type=vals3:Vec type=vals3:T.i32
        for i in vals3 {} // $ MISSING: type=i:i32

        let vals4a: Vec<u16> = [1u16, 2, 3].to_vec(); // $ type=vals4a:Vec type=vals4a:T.u16
        for u in vals4a {} // $ type=u:u16

        let vals4b = [1u16, 2, 3].to_vec(); // $ MISSING: type=vals4b:Vec type=vals4b:T.u16
        for u in vals4b {} // $ MISSING: type=u:u16

        let vals5 = Vec::from([1u32, 2, 3]); // $ type=vals5:Vec target=from type=vals5:T.u32
        for u in vals5 {} // $ type=u:u32

        let vals6: Vec<&u64> = [1u64, 2, 3].iter().collect(); // $ type=vals6:Vec type=vals6:T.&T.u64
        for u in vals6 {} // $ type=u:&T.u64

        let mut vals7 = Vec::new(); // $ target=new type=vals7:Vec type=vals7:T.u8
        vals7.push(1u8); // $ target=push
        for u in vals7 {} // $ type=u:u8

        let matrix1 = vec![vec![1, 2], vec![3, 4]]; // $ MISSING: type=matrix1:Vec type=matrix1:T.Vec type=matrix1:T.T.i32
        #[rustfmt::skip]
        let _ = for row in matrix1 { // $ MISSING: type=row:Vec type=row:T.i32
            for cell in row { // $ MISSING: type=cell:i32
            }
        };

        let mut map1 = std::collections::HashMap::new(); // $ target=new type=map1:K.i32 type=map1:V.Box $ MISSING: type=map1:Hashmap type1=map1:V.T.&T.str
        map1.insert(1, Box::new("one")); // $ target=insert target=new
        map1.insert(2, Box::new("two")); // $ target=insert target=new
        for key in map1.keys() {} // $ target=keys MISSING: type=key:i32
        for value in map1.values() {} // $ target=values MISSING: type=value:Box type=value:T.&T.str
        for (key, value) in map1.iter() {} // $ target=iter MISSING: type=key:i32 type=value:Box type=value:T.&T.str
        for (key, value) in &map1 {} // $ MISSING: type=key:i32 type=value:Box type=value:T.&T.str

        // while loops

        let mut a: i64 = 0; // $ type=a:i64
        #[rustfmt::skip]
        let _ = while a < 10 // $ target=lt type=a:i64
        {
            a += 1; // $ type=a:i64 MISSING: target=add_assign
        };
    }
}

mod explicit_type_args {
    struct S1<T>(T);

    #[derive(Default)]
    struct S2;

    impl<T: Default> S1<T> {
        fn assoc_fun() -> Option<Self> {
            None
        }

        fn default() -> Self {
            S1(T::default()) // $ target=default
        }

        fn method(self) -> Self {
            self
        }
    }

    type S3 = S1<S2>;

    struct S4<T4 = S2>(T4);

    struct S5<T5 = S2> {
        field: T5,
    }

    fn foo<T>(x: T) -> T {
        x
    }

    pub fn f() {
        let x1: Option<S1<S2>> = S1::assoc_fun(); // $ type=x1:T.T.S2 target=assoc_fun
        let x2 = S1::<S2>::assoc_fun(); // $ type=x2:T.T.S2 target=assoc_fun
        let x3 = S3::assoc_fun(); // $ type=x3:T.T.S2 target=assoc_fun
        let x4 = S1::<S2>::method(S1::default()); // $ target=method target=default type=x4:T.S2
        let x5 = S3::method(S1::default()); // $ target=method target=default type=x5:T.S2
        let x6 = S4::<S2>(Default::default()); // $ type=x6:T4.S2 target=default
        let x7 = S4(S2); // $ type=x7:T4.S2
        let x8 = S4(0); // $ type=x8:T4.i32
        let x9 = S4(S2::default()); // $ type=x9:T4.S2 target=default
        let x10 = S5::<S2>  // $ type=x10:T5.S2
        {
            field: Default::default(), // $ target=default
        };
        let x11 = S5 { field: S2 }; // $ type=x11:T5.S2
        let x12 = S5 { field: 0 }; // $ type=x12:T5.i32
        let x13 = S5 // $ type=x13:T5.S2
        {
            field: S2::default(), // $ target=default
        };
        let x14 = foo::<i32>(Default::default()); // $ type=x14:i32 target=default target=foo
    }
}

mod tuples {
    #[derive(Debug, Clone, Copy)]
    struct S1 {}

    impl S1 {
        fn get_pair() -> (S1, S1) {
            (S1 {}, S1 {})
        }
        fn foo(self) {}
    }

    pub fn f() {
        let a = S1::get_pair(); // $ target=get_pair type=a:(T_2)
        let mut b = S1::get_pair(); // $ target=get_pair type=b:(T_2)
        let (c, d) = S1::get_pair(); // $ target=get_pair type=c:S1 type=d:S1
        let (mut e, f) = S1::get_pair(); // $ target=get_pair type=e:S1 type=f:S1
        let (mut g, mut h) = S1::get_pair(); // $ target=get_pair type=g:S1 type=h:S1

        a.0.foo(); // $ target=foo
        b.1.foo(); // $ target=foo
        c.foo(); // $ target=foo
        d.foo(); // $ target=foo
        e.foo(); // $ target=foo
        f.foo(); // $ target=foo
        g.foo(); // $ target=foo
        h.foo(); // $ target=foo

        // Here type information must flow from `pair.0` and `pair.1` into
        // `pair` and from `(a, b)` into `a` and `b` in order for the types of
        // `a` and `b` to be inferred.
        let a = Default::default(); // $ target=default type=a:i64
        let b = Default::default(); // $ target=default type=b:bool
        let pair = (a, b); // $ type=pair:0(2).i64 type=pair:1(2).bool
        let i: i64 = pair.0;
        let j: bool = pair.1;

        let pair = [1, 1].into(); // $ type=pair:(T_2) type=pair:0(2).i32 type=pair:1(2).i32 MISSING: target=into
        match pair {
            (0, 0) => print!("unexpected"),
            _ => print!("expected"),
        }
        let x = pair.0; // $ type=x:i32

        let y = &S1::get_pair(); // $ target=get_pair
        y.0.foo(); // $ target=foo
    }
}

pub mod pattern_matching;
pub mod pattern_matching_experimental {
    pub fn box_patterns() {
        let boxed_value = Box::new(100i32); // $ target=new

        // BoxPat - Box patterns (requires feature flag)
        match boxed_value {
            box 100 => {
                println!("Boxed 100");
            }
            box x => {
                let unboxed = x; // $ MISSING: type=unboxed:i32
                println!("Boxed value: {}", unboxed);
            }
        }

        // Nested box pattern
        let nested_box = Box::new(Box::new(42i32)); // $ target=new
        match nested_box {
            box box x => {
                let nested_unboxed = x; // $ MISSING: type=nested_unboxed:i32
                println!("Nested boxed: {}", nested_unboxed);
            }
        }
    }
}

pub mod exec {
    // a highly simplified model of `MySqlConnection.execute` in SQLx

    trait Connection {}

    trait Executor {
        fn execute1(&self);
        fn execute2<E>(&self, query: E);
    }

    impl<T: Connection> Executor for T {
        fn execute1(&self) {
            println!("Executor::execute1");
        }

        fn execute2<E>(&self, _query: E) {
            println!("Executor::execute2");
        }
    }

    struct MySqlConnection {}

    impl Connection for MySqlConnection {}

    pub fn f() {
        let c = MySqlConnection {}; // $ type=c:MySqlConnection

        c.execute1(); // $ MISSING: target=execute1
        MySqlConnection::execute1(&c); // $ MISSING: target=execute1

        c.execute2("SELECT * FROM users"); // $ MISSING: target=execute2
        c.execute2::<&str>("SELECT * FROM users"); // $ MISSING: target=execute2
        MySqlConnection::execute2(&c, "SELECT * FROM users"); // $ MISSING: target=execute2
        MySqlConnection::execute2::<&str>(&c, "SELECT * FROM users"); // $ MISSING: target=execute2
    }
}

pub mod path_buf {
    // a highly simplified model of `PathBuf::canonicalize`

    pub struct Path {
    }

    impl Path {
        pub const fn new() -> Path {
            Path { }
        }

        pub fn canonicalize(&self) -> Result<PathBuf, ()> {
            Ok(PathBuf::new()) // $ target=new
        }
    }

    pub struct PathBuf {
    }

    impl PathBuf {
        pub const fn new() -> PathBuf {
            PathBuf { }
        }
    }

    // `PathBuf` provides `canonicalize` via `Deref`:
    impl std::ops::Deref for PathBuf {
        type Target = Path;

        #[inline]
        fn deref(&self) -> &Path {
            // (very much not a real implementation)
            static path : Path = Path::new(); // $ target=new
            &path
        }
    }

    pub fn f() {
        let path1 = Path::new(); // $ target=new type=path1:Path
        let path2 = path1.canonicalize(); // $ target=canonicalize
        let path3 = path2.unwrap(); // $ target=unwrap type=path3:PathBuf

        let pathbuf1 = PathBuf::new(); // $ target=new type=pathbuf1:PathBuf
        let pathbuf2 = pathbuf1.canonicalize(); // $ MISSING: target=canonicalize
        let pathbuf3 = pathbuf2.unwrap(); // $ MISSING: target=unwrap type=pathbuf3:PathBuf
    }
}

mod closure;
mod dereference;
mod dyn_type;

fn main() {
    field_access::f(); // $ target=f
    method_impl::f(); // $ target=f
    method_impl::g(method_impl::Foo {}, method_impl::Foo {}); // $ target=g
    method_non_parametric_impl::f(); // $ target=f
    method_non_parametric_trait_impl::f(); // $ target=f
    function_trait_bounds::f(); // $ target=f
    associated_type_in_trait::f(); // $ target=f
    generic_enum::f(); // $ target=f
    method_supertraits::f(); // $ target=f
    function_trait_bounds_2::f(); // $ target=f
    option_methods::f(); // $ target=f
    method_call_type_conversion::f(); // $ target=f
    trait_implicit_self_borrow::f(); // $ target=f
    implicit_self_borrow::f(); // $ target=f
    borrowed_typed::f(); // $ target=f
    try_expressions::f(); // $ target=f
    builtins::f(); // $ target=f
    operators::f(); // $ target=f
    async_::f(); // $ target=f
    impl_trait::f(); // $ target=f
    indexers::f(); // $ target=f
    loops::f(); // $ target=f
    explicit_type_args::f(); // $ target=f
    macros::f(); // $ target=f
    method_determined_by_argument_type::f(); // $ target=f
    tuples::f(); // $ target=f
    exec::f(); // $ target=f
    path_buf::f(); // $ target=f
    dereference::test(); // $ target=test
    pattern_matching::test_all_patterns(); // $ target=test_all_patterns
    pattern_matching_experimental::box_patterns(); // $ target=box_patterns
    dyn_type::test(); // $ target=test
}
