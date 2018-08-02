
class A {
public:
    virtual int f();
};

class B: public A {
public:
    int f() { return 1; }
};

A *p = new A;
int (*pf)() = (int (*)())p->f;


