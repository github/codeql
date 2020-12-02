void f(int);

int t1(int b) {
    int x;
    if (b)
        x = 1;
    f(x); // BAD
    x = 1;
    return x;
}

int t2(int b) {
    int x;
    if (b)
        x = 1;
    else
        x = 2;
    f(x);
    x = 1;
    return x;
}

int t3(int b) {
    int x;
    f(x); // BAD
    x++; // BAD
    x += 1; // BAD
    return x; // BAD
}

int t4(int b) {
    int x = 1;
    f(x);
    return x;
}

int t5(int b) {
    int x;
    x = 1;
    f(x);
    return x;
}

int t6() {
  int x;
  f(x); // BAD
}
