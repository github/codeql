void func_with_default_arg(const int n = 0) {
    if(n <= 10) {}
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
        if(n <= 10) {}
    }
};

const volatile int volatile_const_global = 0;

void test1() {
    func_with_default_arg(100);

    A a(100);
    if(a.int_member <= 10) {}

    if(volatile_const_global <= 10) {}
}

int extreme_values(void)
{
	unsigned long long int x = 0xFFFFFFFFFFFFFFFF;
	unsigned long long int y = 0xFFFFFFFFFFFF;

	if (x >> 1 >= 0xFFFFFFFFFFFFFFFF) {} // always false
	if (x >> 1 >= 0x8000000000000000) {} // always false [NOT DETECTED]
	if (x >> 1 >= 0x7FFFFFFFFFFFFFFF) {} // always true [NOT DETECTED]
	if (x >> 1 >= 0xFFFFFFFFFFFFFFF) {} // always true [NOT DETECTED]

	if (y >> 1 >= 0xFFFFFFFFFFFF) {} // always false [INCORRECT MESSAGE]
	if (y >> 1 >= 0x800000000000) {} // always false [INCORRECT MESSAGE]
	if (y >> 1 >= 0x7FFFFFFFFFFF) {} // always true [INCORRECT MESSAGE]
	if (y >> 1 >= 0xFFFFFFFFFFF) {} // always true [INCORRECT MESSAGE]
}
