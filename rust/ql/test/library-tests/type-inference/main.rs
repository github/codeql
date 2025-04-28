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
    struct GenericThing<A> {
        a: A,
    }

    struct OptionS {
        a: MyOption<S>,
    }

    fn simple_field_access() {
        let x = MyThing { a: S };
        println!("{:?}", x.a); // $ fieldof=MyThing
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
        simple_field_access();
        generic_field_access();
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
        x.m1(); // $ method=m1
        y.m2() // $ method=m2
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

        println!("{:?}", x.m1()); // $ method=MyThing<S1>::m1
        println!("{:?}", y.m1().a); // $ method=MyThing<S2>::m1 fieldof=MyThing

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2()); // $ method=m2
        println!("{:?}", y.m2()); // $ method=m2
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
        x.m1() // $ method=m1
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
            TD::default()
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
        p.fst() // $ method=MyProduct::fst
    }

    fn get_snd<V1, V2, P: MyProduct<V1, V2>>(p: P) -> V2 {
        p.snd() // $ method=MyProduct::snd
    }

    fn get_snd_fst<V0, V1, V2, P: MyProduct<V1, V2>>(p: MyPair<V0, P>) -> V1 {
        p.p2.fst() // $ fieldof=MyPair method=MyProduct::fst
    }

    trait ConvertTo<T> {
        // ConvertTo::convert_to
        fn convert_to(self) -> T;
    }

    impl<T: MyTrait<S1>> ConvertTo<S1> for T {
        // T::convert_to
        fn convert_to(self) -> S1 {
            self.m1() // $ method=m1
        }
    }

    fn convert_to<TS, T: ConvertTo<TS>>(thing: T) -> TS {
        thing.convert_to() // $ method=ConvertTo::convert_to
    }

    fn type_bound_type_parameter_impl<TP: MyTrait<S1>>(thing: TP) -> S1 {
        // The trait bound on `TP` makes the implementation of `ConvertTo` valid
        thing.convert_to() // $ MISSING: method=T::convert_to
    }

    pub fn f() {
        let thing_s1 = MyThing { a: S1 };
        let thing_s2 = MyThing { a: S2 };
        let thing_s3 = MyThing { a: S3 };

        // Tests for method resolution

        println!("{:?}", thing_s1.m1()); // $ method=MyThing<S1>::m1
        println!("{:?}", thing_s2.m1().a); // $ method=MyThing<S2>::m1 fieldof=MyThing
        let s3: S3 = thing_s3.m1(); // $ method=MyThing<S3>::m1
        println!("{:?}", s3);

        let p1 = MyPair { p1: S1, p2: S1 };
        println!("{:?}", p1.m1()); // $ method=MyTrait<I>::m1

        let p2 = MyPair { p1: S1, p2: S2 };
        println!("{:?}", p2.m1()); // $ method=MyTrait<S3>::m1

        let p3 = MyPair {
            p1: MyThing { a: S1 },
            p2: S3,
        };
        println!("{:?}", p3.m1()); // $ method=MyTrait<TT>::m1

        // These calls go to the first implementation of `MyProduct` for `MyPair`
        let a = MyPair { p1: S1, p2: S1 };
        let x = a.fst(); // $ method=MyPair<A,A>::fst
        println!("{:?}", x);
        let y = a.snd(); // $ method=MyPair<A,A>::snd
        println!("{:?}", y);

        // These calls go to the last implementation of `MyProduct` for
        // `MyPair`. The first implementation does not apply as the type
        // parameters of the implementation enforce that the two generics must
        // be equal.
        let b = MyPair { p1: S2, p2: S1 };
        let x = b.fst(); // $ method=MyPair<S2,S1>::fst
        println!("{:?}", x);
        let y = b.snd(); // $ method=MyPair<S2,S1>::snd
        println!("{:?}", y);

        // Tests for inference of type parameters based on trait implementations.

        let x = call_trait_m1(thing_s1); // $ type=x:S1
        println!("{:?}", x);
        let y = call_trait_m1(thing_s2); // $ type=y:MyThing type=y:A.S2
        println!("{:?}", y.a); // $ fieldof=MyThing

        // First implementation
        let a = MyPair { p1: S1, p2: S1 };
        let x = get_fst(a); // $ type=x:S1
        println!("{:?}", x);
        let y = get_snd(a); // $ type=y:S1
        println!("{:?}", y);

        // Second implementation
        let b = MyPair { p1: S2, p2: S1 };
        let x = get_fst(b); // $ type=x:S1
        println!("{:?}", x);
        let y = get_snd(b); // $ type=y:S2
        println!("{:?}", y);

        let c = MyPair {
            p1: S3,
            p2: MyPair { p1: S2, p2: S1 },
        };
        let x = get_snd_fst(c); // $ type=x:S1

        let thing = MyThing { a: S1 };
        let i = thing.convert_to(); // $ MISSING: type=i:S1 method=T::convert_to
        let j = convert_to(thing); // $ type=j:S1
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
        let s1 = x.method(); // $ method=SecondTrait::method
        println!("{:?}", s1); // $ type=s1:I
    }

    fn call_second_trait_per_bound<I: Debug, T: SecondTrait<I>>(x: T) {
        // The type parameter bound determines which method this call is resolved to.
        let s2 = x.method(); // $ method=SecondTrait::method
        println!("{:?}", s2); // $ type=s2:I
    }

    fn trait_bound_with_type<T: FirstTrait<S1>>(x: T) {
        let s = x.method(); // $ method=FirstTrait::method
        println!("{:?}", s); // $ type=s:S1
    }

    fn trait_per_bound_with_type<T: FirstTrait<S1>>(x: T) {
        let s = x.method(); // $ method=FirstTrait::method
        println!("{:?}", s); // $ type=s:S1
    }

    trait Pair<P1, P2> {
        fn fst(self) -> P1;

        fn snd(self) -> P2;
    }

    fn call_trait_per_bound_with_type_1<T: Pair<S1, S2>>(x: T, y: T) {
        // The type in the type parameter bound determines the return type.
        let s1 = x.fst(); // $ method=fst
        let s2 = y.snd(); // $ method=snd
        println!("{:?}, {:?}", s1, s2);
    }

    fn call_trait_per_bound_with_type_2<T2: Debug, T: Pair<S1, T2>>(x: T, y: T) {
        // The type in the type parameter bound determines the return type.
        let s1 = x.fst(); // $ method=fst
        let s2 = y.snd(); // $ method=snd
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
            self.m1() // $ method=m1
        }
    }

    // Type parameter with bound occurs in the root of a parameter type.
    fn call_trait_m1<T1, T2: MyTrait<T1>>(x: T2) -> T1 {
        x.m1() // $ method=m1 type=x.m1():T1
    }

    // Type parameter with bound occurs nested within another type.
    fn call_trait_thing_m1<T1, T2: MyTrait<T1>>(x: MyThing<T2>) -> T1 {
        x.a.m1() // $ fieldof=MyThing method=m1
    }

    impl<T> MyTrait<T> for MyThing<T> {
        fn m1(self) -> T {
            self.a // $ fieldof=MyThing
        }
    }

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1()); // $ method=m1
        println!("{:?}", y.m1()); // $ method=m1

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2()); // $ method=m2
        println!("{:?}", y.m2()); // $ method=m2

        let x2 = MyThing { a: S1 };
        let y2 = MyThing { a: S2 };

        println!("{:?}", call_trait_m1(x2));
        println!("{:?}", call_trait_m1(y2));

        let x3 = MyThing {
            a: MyThing { a: S1 },
        };
        let y3 = MyThing {
            a: MyThing { a: S2 },
        };

        let a = call_trait_thing_m1(x3); // $ type=a:S1
        println!("{:?}", a);
        let b = call_trait_thing_m1(y3); // $ type=b:S2
        println!("{:?}", b);
    }
}

mod trait_associated_type {
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
            self.m1(); // $ method=MyTrait::m1 type=self.m1():AssociatedType
            Self::AssociatedType::default()
        }
    }

    trait MyTraitAssoc2 {
        type GenericAssociatedType<AssociatedParam>;

        // MyTrait::put
        fn put<A>(&self, a: A) -> Self::GenericAssociatedType<A>;

        fn putTwo<A>(&self, a: A, b: A) -> Self::GenericAssociatedType<A> {
            self.put(a); // $ method=MyTrait::put
            self.put(b) // $ method=MyTrait::put
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
        thing.m1() // $ method=MyTrait::m1
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
        println!("{:?}", x1.m1()); // $ method=S::m1 type=x1.m1():AT

        let x2 = S;
        // Call to default method in `trait` block
        let y = x2.m2(); // $ method=m2 type=y:AT
        println!("{:?}", y);

        let x3 = S;
        // Call to the method in `impl` block
        println!("{:?}", x3.put(1).unwrap()); // $ method=S::put method=unwrap

        // Call to default implementation in `trait` block
        println!("{:?}", x3.putTwo(2, 3).unwrap()); // $ method=putTwo MISSING: method=unwrap

        let x4 = g(S); // $ MISSING: type=x4:AT
        println!("{:?}", x4);

        let x5 = S2;
        println!("{:?}", x5.m1()); // $ method=m1 type=x5.m1():A.S2
        let x6 = S2;
        println!("{:?}", x6.m2()); // $ method=m2 type=x6.m2():A.S2

        let assoc_zero = AT.get_zero(); // $ method=get_zero type=assoc_zero:AT
        let assoc_one = AT.get_one(); // $ method=get_one type=assoc_one:S
        let assoc_two = AT.get_two(); // $ method=get_two type=assoc_two:S2
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

        println!("{:?}", x.m1()); // $ method=m1
        println!("{:?}", y.m1()); // $ method=m1
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
        fn m2(self) -> Tr2
        where
            Self: Sized,
        {
            if 1 + 1 > 2 {
                self.m1() // $ method=MyTrait1::m1
            } else {
                Self::m1(self)
            }
        }
    }

    trait MyTrait3<Tr3>: MyTrait2<MyThing<Tr3>> {
        fn m3(self) -> Tr3
        where
            Self: Sized,
        {
            if 1 + 1 > 2 {
                self.m2().a // $ method=m2 $ fieldof=MyThing
            } else {
                Self::m2(self).a // $ fieldof=MyThing
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

    pub fn f() {
        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m1()); // $ method=MyThing::m1
        println!("{:?}", y.m1()); // $ method=MyThing::m1

        let x = MyThing { a: S1 };
        let y = MyThing { a: S2 };

        println!("{:?}", x.m2()); // $ method=m2 type=x.m2():S1
        println!("{:?}", y.m2()); // $ method=m2 type=y.m2():S2

        let x = MyThing2 { a: S1 };
        let y = MyThing2 { a: S2 };

        println!("{:?}", x.m3()); // $ method=m3 type=x.m3():S1
        println!("{:?}", y.m3()); // $ method=m3 type=y.m3():S2
    }
}

mod function_trait_bounds_2 {
    use std::convert::From;
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
        x.into() // $ method=into
    }

    pub fn f() {
        let x = S1;
        println!("{:?}", id(&x));

        let x = S1;
        println!("{:?}", id::<S1>(&x));

        let x = S1;
        println!("{:?}", id::<dyn Trait>(&x)); // incorrectly has type `S1` instead of `Trait`

        let x = S1;
        into::<S1, S2>(x);

        let x = S1;
        let y: S2 = into(x);
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
        let x = t.unwrapSnd().unwrapSnd(); // $ method=unwrapSnd type=x:S3
        println!("{:?}", x);
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

        g(PairOption::PairSnd(PairOption::PairSnd(S3)));
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
            self.set(value); // $ method=MyTrait::set
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
        let x1 = MyOption::<S>::new(); // $ MISSING: type=x1:T.S
        println!("{:?}", x1);

        let mut x2 = MyOption::new();
        x2.set(S); // $ method=MyOption::set
        println!("{:?}", x2);

        let mut x3 = MyOption::new(); // missing type `S` from `MyOption<S>` (but can resolve `MyTrait<S>`)
        x3.call_set(S); // $ method=call_set
        println!("{:?}", x3);

        let mut x4 = MyOption::new();
        MyOption::set(&mut x4, S);
        println!("{:?}", x4);

        let x5 = MyOption::MySome(MyOption::<S>::MyNone());
        println!("{:?}", x5.flatten()); // $ method=flatten

        let x6 = MyOption::MySome(MyOption::<S>::MyNone());
        println!("{:?}", MyOption::<MyOption<S>>::flatten(x6));

        let from_if = if 1 + 1 > 2 {
            MyOption::MyNone()
        } else {
            MyOption::MySome(S)
        };
        println!("{:?}", from_if);

        let from_match = match 1 + 1 > 2 {
            true => MyOption::MyNone(),
            false => MyOption::MySome(S),
        };
        println!("{:?}", from_match);

        let from_loop = loop {
            if 1 + 1 > 2 {
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

    pub fn f() {
        let x1 = S(S2);
        println!("{:?}", x1.m1()); // $ method=m1

        let x2 = S(S2);
        // implicit borrow
        println!("{:?}", x2.m2()); // $ method=m2
        println!("{:?}", x2.m3()); // $ method=m3

        let x3 = S(S2);
        // explicit borrow
        println!("{:?}", S::<S2>::m2(&x3));
        println!("{:?}", S::<S2>::m3(&x3));

        let x4 = &S(S2);
        // explicit borrow
        println!("{:?}", x4.m2()); // $ method=m2
        println!("{:?}", x4.m3()); // $ method=m3

        let x5 = &S(S2);
        // implicit dereference
        println!("{:?}", x5.m1()); // $ method=m1
        println!("{:?}", x5.0); // $ fieldof=S

        let x6 = &S(S2);
        // explicit dereference
        println!("{:?}", (*x6).m1()); // $ method=m1
    }
}

mod trait_implicit_self_borrow {
    trait MyTrait {
        // MyTrait::foo
        fn foo(&self) -> &Self;

        // MyTrait::bar
        fn bar(&self) -> &Self {
            self.foo() // $ method=MyTrait::foo
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
        x.bar(); // $ method=MyTrait::bar
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
        x.foo(); // $ method=foo
    }
}

mod borrowed_typed {
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
        x.f1(); // $ method=f1
        x.f2(); // $ method=f2
        S::f3(&x);
    }
}

fn main() {
    field_access::f();
    method_impl::f();
    method_impl::g(method_impl::Foo {}, method_impl::Foo {});
    method_non_parametric_impl::f();
    method_non_parametric_trait_impl::f();
    function_trait_bounds::f();
    trait_associated_type::f();
    generic_enum::f();
    method_supertraits::f();
    function_trait_bounds_2::f();
    option_methods::f();
    method_call_type_conversion::f();
    trait_implicit_self_borrow::f();
    implicit_self_borrow::f();
    borrowed_typed::f();
}
