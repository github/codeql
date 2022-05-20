typedef int jmp_buf;
void longjmp(jmp_buf env, int val);


[[noreturn]]
void noReturn0();

void noReturn1() {
    noReturn0();
}

void noReturn2() {
    do {
        noReturn0();
    }
    while (0);
}

void noReturn3(int i) {
    if (i > 0) {
        noReturn1();
    } else {
        noReturn2();
    }
}

void noReturn4() {
    while (true) { }
}

void mayReturn(int i) {
    if (i > 0) {
        noReturn0();
    }
}

#define mayReturnMacro(i)   \
    do { if (i > 0) { noReturn0(); } } while (0);

void noReturn5() {
    mayReturnMacro(1);
}

void noReturn6() {
    longjmp(0, 0);
}

void noReturn7() { // NOT REPORTED
    throw 42;
}