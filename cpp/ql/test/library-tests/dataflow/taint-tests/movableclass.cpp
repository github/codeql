
int source();
void sink(...) {};

class MyMovableClass {
public:
	MyMovableClass(int _v = 0) : v(_v) {} // Constructor
	MyMovableClass(MyMovableClass &&other) noexcept { // ConversionConstructor, MoveConstructor
		v = other.v;
		other.v = 0;
	}
	MyMovableClass &operator=(MyMovableClass &&other) noexcept { // MoveAssignmentOperator
		v = other.v;
		other.v = 0;
		return *this;
	}

	int v;
};

MyMovableClass &&getUnTainted() { return MyMovableClass(1); }
MyMovableClass &&getTainted() { return MyMovableClass(source()); }

void test_copyableclass()
{
	{
		MyMovableClass s1(1);
		MyMovableClass s2 = 1;
		MyMovableClass s3;
		s3 = 1;

		sink(s1);
		sink(s2);
		sink(s3);
	}

	{
		MyMovableClass s1(source());
		MyMovableClass s2 = source();
		MyMovableClass s3;
		s3 = source();

		sink(s1); // tainted
		sink(s2); // tainted
		sink(s3); // tainted [NOT DETECTED]
	}

	{
		MyMovableClass s1 = MyMovableClass(source());
		MyMovableClass s2;
		s2 = MyMovableClass(source());

		sink(s1); // tainted
		sink(s2); // tainted [NOT DETECTED]
	}

	{
		MyMovableClass s1(getUnTainted());
		MyMovableClass s2(getTainted());
		MyMovableClass s3;

		sink(s1);
		sink(s2); // tainted
		sink(s3 = source()); // tainted [NOT DETECTED]
	}
}
