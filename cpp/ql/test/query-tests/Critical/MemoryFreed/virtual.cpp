
class ca {};
class cb {};
class cc {};
class cd {};

// --- myBaseClass ---

class myBaseClass
{
public:
	myBaseClass() {
		a = new ca; // GOOD
		b = new cb; // GOOD
	}

	virtual ~myBaseClass() {
		delete a;
		delete c;
	}

protected:
	ca *a;
	cb *b;
	cc *c;
	cd *d;
};

class myDerivedClass : public myBaseClass
{
public:
	myDerivedClass() {
		c = new cc; // GOOD
		d = new cd; // GOOD
	}

	~myDerivedClass() {
		delete b;
		delete d;
	}
};

void virtual_test()
{
	myBaseClass *c = new myDerivedClass();
	delete c;
}