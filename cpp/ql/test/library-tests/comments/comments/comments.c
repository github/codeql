
int f /* on secondary f */ (char x /* on secondary x */);

extern int i /* on secondary i */;

int f /* on f */ (char x /* on x */) {
    int j /* on j */;

    return 5;
}

int i /* on i */;

void f2(void) {
    extern f2i; // On f2i
}

void f3a(void) { 
    static void (*fp)(void);
}

// On f3b
static void f3b(void);

// On define FOO
#define FOO bar

// On undef FOO
#undef FOO

// On struct my_struct
struct my_struct {
    int i;
};

// On union my_union
union my_union {
    int i;
    char c;
};

// This is a legal alternative way to achieve a \
multi-line comment on j.
int j;
