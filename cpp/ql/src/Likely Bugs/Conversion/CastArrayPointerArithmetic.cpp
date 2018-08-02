class Base {
public:
	int x;
}

class Derived: public Base {
public:
	int y;
};

void dereference_base(Base *b) {
	b[2].x;
}

void dereference_derived(Derived *d) {
	d[2].x;
}

void test () {
	Derived[4] d;
	dereference_base(d); // BAD: implicit conversion to Base*

	dereference_derived(d); // GOOD: implicit conversion to Derived*, which will be the right size
}
