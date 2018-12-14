class Base {
public:
    Resource *p;
    Base() {
        p = createResource();
    }
    //...
    ~Base() {
        //wrong: this destructor is non-virtual, but Base has a derived class
        //with a non-virtual destructor
        freeResource(p);
    }
};

class Derived: public Base {
public:
    Resource *dp;
    Derived() {
        dp = createResource2();
    }
    ~Derived() {
        freeResource2(dp);
    }
};

int f() {
    Base *b = new Derived(); //creates resources for both Base::p and Derived::dp
    //...
    delete b; //will only call Base::~Base(), leaking the resource dp.
        // Change both destructors to virtual to ensure they are both called.
}
