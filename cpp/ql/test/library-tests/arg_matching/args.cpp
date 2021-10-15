void global_0();
void global_1(int a);
void global_2(int a, float b);
void global_2_vararg(int a, float b, ...);

void call_globals(int a, float b, void* c, bool d) {
    global_0();
    global_1(a);
    global_2(a, b);
    global_2_vararg(a, b);
    global_2_vararg(a, b, c);
    global_2_vararg(a, b, c, d);
}

void (*pfn_0)();
void (*pfn_1)(int a);
void (*pfn_2)(int a, float b);
void (*pfn_2_vararg)(int a, float b ...);

void call_pfns(int a, float b, void* c, bool d) {
    pfn_0();
    pfn_1(a);
    pfn_2(a, b);
    pfn_2_vararg(a, b);
    pfn_2_vararg(a, b, c);
    pfn_2_vararg(a, b, c, d);
}

struct S {
    S();
    S(int a);
    S(int a, float b, ...);
};

void call_constructors(int a, float b, void* c, bool d) {
    S s0;
    S s1(a);
    S s2_vararg_0(a, b);
    S s2_vararg_1(a, b, c);
    S s2_vararg_2(a, b, c, d);
}
