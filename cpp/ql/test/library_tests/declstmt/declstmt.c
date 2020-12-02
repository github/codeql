
int topLevel1, topLevel2;

int x = 1;

void fun(void) {
    int fun1, fun2;

    int y = 2;
    extern int x;
    void some_fun();
    typedef int my_int;
    int z;

    int i1a[sizeof(struct S1 { int i; })] = { ({ int x = 3; int y = 4; 5; }) }, i1b;
    extern int i2a[sizeof(struct S2 { int i; })], i2b;

    int nested_x = ({ extern int nested_y; 1; }), nested_y;

    extern int repeated_var;
    extern int repeated_var;
    void repeated_fun();
    void repeated_fun();
}

void another_fun(void) {
    extern int repeated_var;
    void repeated_fun();
}

