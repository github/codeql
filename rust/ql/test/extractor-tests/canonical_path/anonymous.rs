use super::regular::Trait;

fn canonicals() {
    struct OtherStruct;

    trait OtherTrait {
        fn g(&self);
    }

    impl OtherTrait for OtherStruct {
        fn g(&self) {}
    }

    impl OtherTrait for crate::regular::Struct {
        fn g(&self) {}
    }

    impl crate::regular::Trait for OtherStruct {
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
