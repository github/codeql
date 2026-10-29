use crate::macro_expansion;

fn call_some_functions() {
    macro_expansion::foo();
    macro_expansion::foo_new();
    macro_expansion::bar_0();
    macro_expansion::bar_1();
    macro_expansion::bar_0_new();
    macro_expansion::bar_1_new();
    macro_expansion::S::bzz_0();
    macro_expansion::S::bzz_1();
    macro_expansion::S::bzz_2();
    macro_expansion::S::x();
}