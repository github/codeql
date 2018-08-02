
int global = 0;

int pure(void) {
    return global;
}

int impure(void) {
    return global++;
}

void f(void) {
    int i;
    int *ip;
    int volatile vi;
    int * volatile vip;

    sizeof(i);
    sizeof(vi);
    sizeof(*ip);
    sizeof(*vip);
    sizeof(global++);
    sizeof(pure());
    sizeof(impure());
}

