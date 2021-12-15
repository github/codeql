
int source();
void sink(...);

class MyCopyableClass {
public:
	MyCopyableClass() {} // Constructor
	MyCopyableClass(int _v) : v(_v) {} // ConversionConstructor
	MyCopyableClass(const MyCopyableClass &other) : v(other.v) {} // CopyConstructor
	MyCopyableClass &operator=(const MyCopyableClass &other) { // CopyAssignmentOperator
		v = other.v;
		return *this;
	}

	int v;
};

void test_copyableclass()
{
	{
		MyCopyableClass s1(1);
		MyCopyableClass s2 = 1;
		MyCopyableClass s3(s1);
		MyCopyableClass s4;
		s4 = 1;

		sink(s1);
		sink(s2);
		sink(s3);
		sink(s4);
	}

	{
		MyCopyableClass s1(source());
		MyCopyableClass s2 = source();
		MyCopyableClass s3(s1);
		MyCopyableClass s4;
		s4 = source();

		sink(s1); // $ ast,ir
		sink(s2); // $ ast,ir
		sink(s3); // $ ast,ir
		sink(s4); // $ ast,ir
	}

	{
		MyCopyableClass s1;
		MyCopyableClass s2 = s1;
		MyCopyableClass s3(s1);
		MyCopyableClass s4;
		s4 = s1;

		sink(s1);
		sink(s2);
		sink(s3);
		sink(s4);
	}

	{
		MyCopyableClass s1 = MyCopyableClass(source());
		MyCopyableClass s2;
		MyCopyableClass s3;
		s2 = MyCopyableClass(source());

		sink(s1); // $ ast,ir
		sink(s2); // $ ast,ir
		sink(s3 = source()); // $ ast,ir
	}
}
