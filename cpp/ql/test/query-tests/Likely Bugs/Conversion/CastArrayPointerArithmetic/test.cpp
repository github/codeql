//

class Base {
public:
	int x;
private:
	char c;
};

class Derived: public Base {
public:
	int y;
};

class Derived2: public Derived {
};

class DerivedNoField: public Base {
};

class DerivedSameSize: public Base {
public:
	char c2;
};

void dereference_base(Base *b) {
	b[2].x;
}

void dereference_array_base(Base b[]) {
	b[2].x;
}

void pointer_arith_base(Base *b) {
	b + 2;
}

void dereference_derived(Derived *d) {
	d[2].x;
}

void dereference_array_derived(Derived d[]) {
	d[2].x;
}

void pointer_arith_derived(Derived *d) {
	d + 2;
}

void char_pointer_arith(Base *b) {
	((char*) b)[2];
}

void test () {
	Derived d[4];

	dereference_base(d); // BAD: implicit conversion to Base*
	dereference_array_base(d); // BAD: implicit conversion to Base*
	pointer_arith_base(d); // BAD: implicit conversion to Base*

	dereference_derived(d); // GOOD: implicit conversion to Derived*, which will be the right size
	dereference_array_derived(d); // GOOD: implicit conversion to Derived*, which will be the right size
	pointer_arith_derived(d); // GOOD: implicit conversion to Derived*, which will be the right size


	Base b[4];

	dereference_base(b); // BAD: implicit conversion to Base*
	dereference_array_base(b); // BAD: implicit conversion to Base*
	pointer_arith_base(b); // BAD: implicit conversion to Base*

	DerivedSameSize dss[4];

	dereference_base(dss); // BAD: same size on Linux but different on Windows
	dereference_array_base(dss); // BAD: same size on Linux but different on Windows
	pointer_arith_base(dss); // BAD: same size on Linux but different on Windows

	DerivedNoField dnf[4];

	dereference_base(dnf); // GOOD: no new field introduced
	dereference_array_base(dnf); // GOOD: no new field introduced
	pointer_arith_base(dnf); // GOOD: no new field introduced

	Derived2 d2[4];

	dereference_base(d2); // BAD: implicit conversion to Base*
	dereference_array_base(d2); // BAD: implicit conversion to Base*
	pointer_arith_base(d2); // BAD: implicit conversion to Base*

	dereference_derived(d2); // GOOD: implicit conversion to Derived*, which will be the right size
	dereference_array_derived(d2); // GOOD: implicit conversion to Derived*, which will be the right size
	pointer_arith_derived(d2); // GOOD: implicit conversion to Derived*, which will be the right size

	char_pointer_arith(b); // GOOD: pointer arithmetic is done with char*
	char_pointer_arith(d); // GOOD: pointer arithmetic is done with char*
	char_pointer_arith(dss); // GOOD: pointer arithmetic is done with char*

}
