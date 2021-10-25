
struct MyStruct
{
	int x, y, z, w;
};

void test(MyStruct *ptr)
{
	MyStruct *new_ptr = ptr + 1; // GOOD
}
