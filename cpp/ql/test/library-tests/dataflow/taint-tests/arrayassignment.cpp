
int source();
void sink(int);
void sink(class MyInt);
void sink(class MyArray);

void test_pointer_deref_assignment()
{
	int x = 0;
	int *p_x = &x;
	int *p2_x = &x;
	int &r_x = x;

	*p_x = source();

	sink(x); // $ MISSING: ir
	sink(*p_x); // $ ir
	sink(*p2_x); // $ MISSING: ir
	sink(r_x); // $ MISSING: ir
}

void test_reference_deref_assignment()
{
	int x = 0;
	int *p_x = &x;
	int &r_x = x;
	int &r2_x = x;

	r_x = source();

	sink(x); // $ MISSING: ir
	sink(*p_x); // $ MISSING: ir
	sink(r_x); // $ ir
	sink(r2_x); // $ MISSING: ir
}

class MyInt
{
public:
	MyInt() : i(0) {}

	int &get() { return i; }

	MyInt &operator=(const int &other);
	MyInt &operator=(const MyInt &other);

	int i;
};

void test_myint_member_assignment()
{
	MyInt mi;

	mi.i = source();

	sink(mi); // $ MISSING: ir
	sink(mi.get()); // $ ir
}

void test_myint_method_assignment()
{
	MyInt mi;

	mi.get() = source();

	sink(mi); // $ MISSING: ir
	sink(mi.get()); // $ MISSING: ir
}

void test_myint_overloaded_assignment()
{
	MyInt mi, mi2;

	mi = source();
	mi2 = mi;

	sink(mi); // $ MISSING: ir
	sink(mi.get()); // $ MISSING: ir
	sink(mi2); // $ MISSING: ir
	sink(mi2.get()); // $ MISSING: ir
}

class MyArray
{
public:
	MyArray() : values({0}) {}

	int &get(int i) { return values[i]; }

	int &operator[](int i);

	int values[10];
};

void test_myarray_member_assignment()
{
	MyArray ma;

	ma.values[0] = source();

	sink(ma.values[0]); // $ ir
}

void test_myarray_method_assignment()
{
	MyArray ma;

	ma.get(0) = source();

	sink(ma.get(0)); // $ MISSING: ir
}

void test_myarray_overloaded_assignment()
{
	MyArray ma, ma2;

	ma[0] = source();
	ma2 = ma;

	sink(ma[0]); // $ MISSING: ir
	sink(ma2[0]); // $ MISSING: ir
}

void sink(int *);

void test_array_reference_assignment()
{
	int arr1[10] = {0};
	int arr2[10] = {0};
	int arr3[10] = {0};
	int &ref1 = arr1[5];
	int *ptr2, *ptr3;

	ref1 = source();
	sink(ref1); // $ ir
	sink(arr1[5]); // $ MISSING: ir

	ptr2 = &(arr2[5]);
	*ptr2 = source();
	sink(*ptr2); // $ ir
	sink(arr2[5]); // $ MISSING: ir

	ptr3 = arr3;
	ptr3[5] = source();
	sink(ptr3[5]); // $ ir
	sink(arr3[5]); // $ MISSING: ir
}
