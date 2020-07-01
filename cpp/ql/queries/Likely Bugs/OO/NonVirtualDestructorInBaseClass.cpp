class Base {
public:
	Resource *p;
	Base() {
		p = createResource();
	}
	virtual void f() { //has virtual function
		//...
	}
	//...
	~Base() { //wrong: is non-virtual
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

	//will only call Base::~Base(), leaking the resource dp.
	//Change both destructors to virtual to ensure they are both called.
	delete b;
}
