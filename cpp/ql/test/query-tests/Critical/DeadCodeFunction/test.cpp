 
static void usedByUnused() {
}

static void unused() {
    usedByUnused();
}

class Base {
    virtual void f() { }
public:
    Base() { }
 
    void process() {
        f();
    }
};
 
class Derived : public Base {
    virtual void f() { }
public:
    Derived() { }
};
 
void caller() {
    Base b;
    Derived d;
 
    b.process();
    d.process();
}

