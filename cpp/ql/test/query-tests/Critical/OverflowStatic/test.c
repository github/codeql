
char xs[5];
struct {
    char ys[5];
    char zs[0];
} stru;

void f(void) {
    char c;

    c = xs[-1]; // BAD [NOT DETECTED]
    c = xs[0]; // GOOD
    c = xs[4]; // GOOD
    c = xs[5]; // BAD
    c = xs[6]; // BAD

    c = stru.ys[-1]; // BAD [NOT DETECTED]
    c = stru.ys[0]; // GOOD
    c = stru.ys[4]; // GOOD
    c = stru.ys[5]; // BAD
    c = stru.ys[6]; // BAD

    c = stru.zs[-1]; // BAD [NOT DETECTED]
    c = stru.zs[0]; // GOOD (zs is variable size)
    c = stru.zs[4]; // GOOD (zs is variable size)
    c = stru.zs[5]; // GOOD (zs is variable size)
    c = stru.zs[6]; // GOOD (zs is variable size)
}

