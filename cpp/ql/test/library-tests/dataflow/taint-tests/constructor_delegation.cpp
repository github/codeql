
int source();
void sink(...);

class MyValue
{
public:
	MyValue(int _x) : x(_x) {}; // taint flows from parameter `_x` to member variable `x`
	MyValue(int _x, bool ex) : MyValue(_x) {}; // taint flows from parameter `_x` to member variable `x`
	MyValue(int _x, int _y) : MyValue(_x + _y) {}; // taint flows from parameters `_x` and `_y` to member variable `x`
	MyValue(int _x, bool ex1, bool ex2) : MyValue(0) {}; // taint doesn't flow from parameter `_x`

	int x;
};

class MyDerivedValue : public MyValue
{
public:
	MyDerivedValue(bool ex, int _x) : MyValue(_x) {}; // taint flows from parameter `_x` to member variable `x`
};

void test_inits()
{
	MyValue v1(0);
	MyValue v2(source());
	MyValue v3(0, true);
	MyValue v4(source(), true);
	MyValue v5(0, 1);
	MyValue v6(source(), 1);
	MyValue v7(0, source());
	MyValue v8(0, true, true);
	MyValue v9(source(), true, true);
	MyDerivedValue v10(true, 0);
	MyDerivedValue v11(true, source());

	sink(v1.x);
	sink(v2.x); // $ ast,ir
	sink(v3.x);
	sink(v4.x); // $ ir MISSING: ast
	sink(v5.x);
	sink(v6.x); // $ ir MISSING: ast
	sink(v7.x); // $ ir MISSING: ast
	sink(v8.x);
	sink(v9.x);
	sink(v10.x);
	sink(v11.x); // $ ir MISSING: ast
}
