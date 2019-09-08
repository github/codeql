
struct MyStruct
{
	int x;
	struct MySubStruct {
		int z;
	} y;
};

void test()
{
	MyStruct s;

	s.x = 1;
	s.y.z = 1;
}
