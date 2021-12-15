// note the two different `MyStruct` definitions, in test_small.cpp and test_large.cpp.  These are
// in different translation units and we assume they are never linked into the same program (which
// would result in undefined behaviour).

struct MyStruct
{
	int x, y;
};

void test(MyStruct *ptr)
{
	MyStruct *new_ptr = ptr + 1; // GOOD
}
