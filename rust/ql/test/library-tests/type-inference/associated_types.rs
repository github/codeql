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

    pub fn test() {
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

    pub fn test() {
        let item1 = MyType(42i64);
        let _content1 = item1.get_content(); // $ target=MyType::get_content MISSING: type=_content1:i64

        let item2 = MyType(true);
        let _content2 = get_content(&item2); // $ target=get_content MISSING: type=_content2:bool
    }
}

mod generic_associated_type_name_clash {
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

    pub fn test() {
        let _y = GenS(true).get_input(); // $ type=_y:Result type=_y:T.bool type=_y:E.bool target=get_input
    }
}

pub fn test() {
    associated_type_in_trait::test(); // $ target=test
    associated_type_in_supertrait::test(); // $ target=test
    generic_associated_type_name_clash::test(); // $ target=test
}
