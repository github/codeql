
int source();
void sink(...);

class MyCopyableClassDeclOnly {
public:
	MyCopyableClassDeclOnly(); // Constructor
	MyCopyableClassDeclOnly(int _v); // ConversionConstructor
	MyCopyableClassDeclOnly(const MyCopyableClassDeclOnly &other); // CopyConstructor
	MyCopyableClassDeclOnly &operator=(const MyCopyableClassDeclOnly &other); // CopyAssignmentOperator




	int v;
};

void test_copyableclass_declonly()
{
	{
		MyCopyableClassDeclOnly s1(1);
		MyCopyableClassDeclOnly s2 = 1;
		MyCopyableClassDeclOnly s3(s1);
		MyCopyableClassDeclOnly s4;
		s4 = 1;

		sink(s1);
		sink(s2);
		sink(s3);
		sink(s4);
	}

	{
		MyCopyableClassDeclOnly s1(source());
		MyCopyableClassDeclOnly s2 = source();
		MyCopyableClassDeclOnly s3(s1);
		MyCopyableClassDeclOnly s4;
		s4 = source();

		sink(s1); // $ ast,ir
		sink(s2); // $ ast,ir
		sink(s3); // $ ast,ir
		sink(s4); // $ ast,ir
	}

	{
		MyCopyableClassDeclOnly s1;
		MyCopyableClassDeclOnly s2 = s1;
		MyCopyableClassDeclOnly s3(s1);
		MyCopyableClassDeclOnly s4;
		s4 = s1;

		sink(s1);
		sink(s2);
		sink(s3);
		sink(s4);
	}

	{
		MyCopyableClassDeclOnly s1 = MyCopyableClassDeclOnly(source());
		MyCopyableClassDeclOnly s2;
		MyCopyableClassDeclOnly s3;
		s2 = MyCopyableClassDeclOnly(source());

		sink(s1); // $ ast,ir
		sink(s2); // $ ast,ir
		sink(s3 = source()); // $ ast,ir
	}
}
