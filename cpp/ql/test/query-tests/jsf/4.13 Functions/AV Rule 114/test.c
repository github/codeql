
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
