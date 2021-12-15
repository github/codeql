
struct mystruct {
    int f1;
    int f2;
};

typedef int size_t;

#define edg_offsetof(t, memb) ((size_t)__INTADDR__(&(((t *)0)->memb)))

void f(void) {
    int i1 = __builtin_offsetof(struct mystruct,f2);
    int i2 = edg_offsetof(struct mystruct,f2);
}

