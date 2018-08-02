
#define foo "/*bar"
#define bar aaa \ bbb

int i;

void f(void) {
    i = 1;
    i = 2;
    i = 3;
}

void g(void) {
    i = 1;
    i = 2;
    i = 3;
}

