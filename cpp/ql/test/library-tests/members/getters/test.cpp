
class C {
public:
    template <typename T>
    void f_template_C(T t) { }

    template <typename T>
    void f_template_C_D(T t) { }

    void f_C(void) { }
    void f_C_D(void) { }
};

class D : public C {
public:
    template <typename T>
    void f_template_C_D(T t) { }

    template <typename T>
    void f_template_D(T t) { }

    void f_C_D(void) { }
    void f_D(void) { }
};

template <typename T>
class E {
public:
    void f_E(void) {}

    void f_E_arg(E e) {}
};

void g(void) {
    int vi;
    double vd;

    C c;
    c.f_template_C(vi);
    c.f_template_C_D(vi);
    c.f_C();
    c.f_C_D();
    D d;
    d.f_template_C(vd);
    d.f_template_C_D(vd);
    d.f_template_D(vd);
    d.f_C();
    d.f_C_D();
    d.f_D();

    E<int> e;
    e.f_E();
    e.f_E_arg(e);
}

