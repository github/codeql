// semmle-extractor-options: -std=c23
int f1(void) {
    int x = 1;
    return 2;
}

int f2(void) {
    int x = 1;
} // BAD

int f3(int b) {
    int x;
    if (b) {
        x = 1;
        return 2;
    } else {
        x = 3;
        return 4;
    }
}

int f4(int b) {
    int x;
    if (b) {
        x = 1;
    } else {
        x = 3;
        return 4;
    }
} // BAD

int f5(void) {
    __builtin_unreachable();
}

int f6(int b) {
    int x;
    if (b) {
        x = 1;
    } else {
        __builtin_unreachable();
    }
} // BAD

int f7(int b) {
    int x;
    do {
        x = 1;
        __builtin_unreachable();
    } while (0);
}

void f8() {
    return;
}

void f9() {
}

void exit(int status);

int f10() {
    exit(1);
}

int f11(int x)
{
    if (x < 10)
    {
        return x;
    } else {
        f10(); // GOOD
    }
}

int f12(int x)
{
    while (1)
    {
        // ...

        if (x == 10) return 1; // GOOD

        // ...
    }
}

void f13()
{
	f13_func(); // implicitly declared here
}

void f13_func(int x)
{
	if (x < 10) return; // GOOD
}

int f14()
{
	__asm__("rdtsc"); // GOOD
}

_Noreturn void f15();

int f16() {
    f15(); // GOOD
}

int f17() {
    if (__builtin_expect(1, 0))
        __builtin_unreachable(); // GOOD
}

[[_Noreturn]] void f18();

int f19() {
    f18(); // GOOD
}

[[___Noreturn__]] void f20();

int f21() {
    f20(); // GOOD
}

[[noreturn]] void f22();

int f23() {
    f22(); // GOOD
}

[[__noreturn__]] void f24();

int f25() {
    f24(); // GOOD
}
