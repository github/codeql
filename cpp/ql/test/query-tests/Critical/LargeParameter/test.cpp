
struct mySmallStruct {
	char data[4];
};

struct myLargeStruct {
	char data[4096];
};

template <class T>
class myTemplateClass
{
public:
	myTemplateClass() {}

	void set(T _t) { // BAD: T can be myLargeStruct, which is large
		t = _t;
	}

	T t;
};

template<class T>
void myTemplateFunction(myTemplateClass<T> mtc_t) // BAD: T can be myLargeStruct, which is large
{
}

void myFunction1(mySmallStruct a, myLargeStruct b) // BAD: b is large
{
	myTemplateClass<mySmallStruct> mtc_a;
	myTemplateClass<myLargeStruct> mtc_b;

	mtc_a.set(a);
	mtc_b.set(b);

	myTemplateFunction(mtc_a);
	myTemplateFunction(mtc_b);
}

void myFunction2(mySmallStruct *a, myLargeStruct *b) // GOOD
{
}

void myFunction3(mySmallStruct &a, myLargeStruct &b) // GOOD
{
}

struct CustomAssignmentOp {
  // GOOD: it's an accepted pattern to implement copy assignment via copy and
  // swap. This delegates the resource management involved in copying to the
  // copy constructor so that logic only has to be written once.
  CustomAssignmentOp &operator=(CustomAssignmentOp rhs);
  char data[4096];
};

// ---

struct MyLargeClass {
public:
	MyLargeClass();

	void myMethod();
	void myConstMethod() const;

	int value;
	char data[4096];
};

void mlc_modify(MyLargeClass &c) {
	c.value++;
}

int mlc_get(const MyLargeClass &c) {
	return c.value;
}

void myFunction4(
		MyLargeClass a, // GOOD: large, but the copy is written to so can't be trivially replaced with a reference
		MyLargeClass b, // GOOD
		MyLargeClass c, // GOOD
		MyLargeClass d, // GOOD
		MyLargeClass e, // GOOD
		MyLargeClass f, // GOOD
		MyLargeClass g // GOOD
	)
{
	MyLargeClass *mlc_ptr;
	int *i_ptr;
	
	a.value++;
	b.value = 1;
	c.data[0] += 1;
	d.myMethod();
	mlc_modify(e);

	mlc_ptr = &f;
	mlc_modify(*mlc_ptr);

	i_ptr = &g.value;
	*(i_ptr)++;
}

void myFunction5(
		MyLargeClass a, // BAD
		MyLargeClass b, // BAD
		MyLargeClass c, // BAD
		MyLargeClass d, // BAD
		MyLargeClass e, // BAD
		MyLargeClass f // BAD
	)
{
	const MyLargeClass *mlc_ptr;
	const int *i_ptr;
	int i;
	
	i = a.value;
	i += b.data[0];
	c.myConstMethod();
	i += mlc_get(d);

	mlc_ptr = &e;
	mlc_get(*mlc_ptr);

	i_ptr = &f.value;
	i += *i_ptr;
}

// ---

class MyArithmeticClass {
public:
	MyArithmeticClass(int _value) : value(_value) {};

	MyArithmeticClass &operator+=(const MyArithmeticClass &other) {
		this->value += other.value;
		return *this;
	}

private:
	int value;
	char data[1024];
};

MyArithmeticClass operator+(MyArithmeticClass lhs, const MyArithmeticClass &rhs) { // GOOD
	lhs += rhs; // lhs is copied by design
	return lhs;
}

void myFunction6(MyLargeClass a); // GOOD (no definition, so we can't tell what's done with `a`)

// ---

struct big
{
	int xs[800];
	int *ptr;
};

void myFunction7(
		big a, // GOOD
		big b // BAD
	)
{
	a.xs[0]++; // modifies a
	b.ptr[0]++; // does not modify b
}
