
#define mymacro1(x) x
#define mymacro2(x) mymacro1(x)

int x = mymacro2(1 + 2);

void f(int x) { };
void g(int x) { };
#define fgmacro(x) f(x); g(x)
void fg(int x) {
    fgmacro(x);
}

#define MM(name) extern int name (int)
MM(foo);
