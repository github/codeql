mod a {
    #[derive(Eq, PartialEq)]
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

    fn free() {}

    fn usage() {
        let s = Struct {};
        s.f();
        s.g();
        s.h();
        free();
    }
}

mod without {
    use super::a::Trait;

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

        fn usage() {
            let s = OtherStruct {};
            s.f();
            s.g();
            nested();
        }
    }

    fn other() {
        struct OtherStruct;
    }
}
