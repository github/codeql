
int topLevel = 0;

int f1(void) {
    int i;

    i = 2;

    return i;
}

int f2(void) {
    int i = 0;

    i = 2;

    return i;
}

int f3(void) {
    int i = 0;

    i = 2;
    i++;

    return i;
}

int f4(void) {
    static int i = 0;

    i++;

    return i;
}

void f5(void) {
    int x;
    int y;
    x = 7;
    y = x++;
    x = 8;
}

void f6(void) {
    int x;
    int y;
    x = 7;
    y = topLevel++;
    x = 8;
}

int f7(int x) {
    switch(x) {
        case 1:
            return 3;
        case 2:
            break;
        default:
            return 4;
    }
    return 5;
}

void f8(void) {
    int x;
    for (x = 3; x < 10; x++) { }
    for (x = 3; x < 10;    ) { }
    for (x = 3;       ; x++) { }
    for (x = 3;       ;    ) { }
    for (     ; x < 10; x++) { }
    for (     ; x < 10;    ) { }
    for (     ;       ; x++) { }
    for (     ;       ;    ) { }
}

void (*funPointer)(void);

void f9(void) {
    funPointer();
}

int fib(int x) {
    if (x < 2) {
        return x;
    } else {
        return fib(x - 2) + fib(x - 1);
    }
}

void mut1(int x);
void mut2(int x);

void mut1(int x) {
    if (x != 0) {
        mut2(x - 1);
    }
}

void mut2(int x) {
    if (x != 0) {
        mut1(x - 1);
    }
}

