
int f1(int p) {
    int i;

    for (
		i = 0;
		i < 10;
		++i,
		++p) {
    }

    return p;
}

int global_int;

int f2(void) {
    global_int = 3;
    return 1;
}

int f3(void) {
    return 2;
}

void f4(void) {
    int is0[3] = { 3, 4, 5 };
    int is1[3] = { 3, f2(), 5 };
    int is2[3] = { 3, f3(), 5 };
}
