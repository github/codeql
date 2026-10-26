
void abort(void);

class Base {
public:
    virtual int f() {
        abort();
    }

    int Base_f() {
        int i = Base::f();
        return 1;
    }

    virtual int g() {
        return 3;
    }

    int Base_g() {
        int i = Base::g();
        return 4;
    }
};

int fun_f1(void) {
    Base* p1 = new Base();
    int i = p1->f();
    return 2;
}

int fun_f2(void) {
    Base* p1 = new Base();
    int i = p1->Base::f();
    return 2;
}

int fun_g1(void) {
    Base* p1 = new Base();
    int i = p1->g();
    return 2;
}

int fun_g2(void) {
    Base* p1 = new Base();
    int i = p1->Base::g();
    return 2;
}

