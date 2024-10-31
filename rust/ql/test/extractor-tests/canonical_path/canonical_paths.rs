mod a {
    pub struct Struct;

    pub trait Trait {
        fn f(&self);
    }

    impl Trait for Struct {
        fn f(&self) {}
    }

    impl Struct {
        fn g(&self) {}
    }

    trait TraitWithBlanketImpl {
        fn h(&self);
    }

    impl<T: Eq> TraitWithBlanketImpl for T {
        fn h(&self) {}
    }
}

mod without {
    fn canonicals() {
        struct OtherStruct;

        trait OtherTrait {
            fn g(&self);
        }

        impl OtherTrait for OtherStruct {
            fn g(&self) {}
        }

        impl OtherTrait for crate::canonical_paths::a::Struct {
            fn g(&self) {}
        }

        impl crate::canonical_paths::a::Trait for OtherStruct {
            fn f(&self) {}
        }

        fn nested() {
            struct OtherStruct;
        }
    }

    fn other() {
        struct OtherStruct;
    }
}
