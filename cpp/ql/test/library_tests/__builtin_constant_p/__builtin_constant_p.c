
extern int g(void);

void f(int i) {
    static const int i1 = 1;
    static const int i2 = g();
    static const int i3 = i;
    static const int i4 = __builtin_constant_p(i);
    static const int i5 = 5;

    char str[0 - !__builtin_constant_p(i)];
}

