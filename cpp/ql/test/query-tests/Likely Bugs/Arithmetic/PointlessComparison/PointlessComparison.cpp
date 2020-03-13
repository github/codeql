void func_with_default_arg(const int n = 0) {
    if(n <= 10) {} // GOOD [FALSE POSITIVE]
}

struct A {
    const int int_member = 0;
    A(int n) : int_member(n) {
        if(int_member <= 10) {
                    
        }
    }
};

struct B {
    B(const int n = 0) {
        if(n <= 10) {} // GOOD [FALSE POSITIVE]
    }
};

const volatile int volatile_const_global = 0;

void test1() {
    func_with_default_arg(100);

    A a(100);
    if(a.int_member <= 10) {}

    if(volatile_const_global <= 10) {} // GOOD [FALSE POSITIVE]
}