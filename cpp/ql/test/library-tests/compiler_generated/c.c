
void f1(void) {
    int x;
    long y;
    long long z;
    x = 3;
    y = x; // Compiler generated cast
    z = x; // Compiler generated cast
    // Compiler generated return
}

void f2(void) {
    int x;
    x = 3;
    return;
}

void f3(void) {
    int x;
    x = 3;
    return;
    x = 4;
    // No compiler generated return here, as this is unreachable
}

void f4(void) {
    int x;
    while (1) {
        x = 3;
    }
    // No compiler generated return here, as this is unreachable
}

