
struct C {
    ~C()  { }
};

struct D {
    C c;
    D() : c() { }
};

struct E {
    D d;
    E(int *i) {}
};

extern int* w;

struct F {
    E *fun(const E& domain = w) const;
};

void g(E& domain, F *f) {
    E *e = f->fun(domain);
}

