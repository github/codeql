template <int i>
struct [[align(i)]] myStruct {
    int j;
};
myStruct<128> s;

template <int x> int foo() __attribute__((aligned(x))) { return 1; }
int bar() { return foo<1024>(); }
