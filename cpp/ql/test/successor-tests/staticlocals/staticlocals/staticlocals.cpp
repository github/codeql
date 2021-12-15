int g() {
    return 1;
}

int h() {
    return 1;
}

void f() {
    static int i = g(), j = h();
    static int k = g();
    ;
}
