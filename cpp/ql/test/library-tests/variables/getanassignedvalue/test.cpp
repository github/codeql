
void test1()
{
	int v = 10; // assignment to `v`
	int *ptr_v = &v; // assignment to `ptr_v`
	int &ref_v = v; // assignment to `ref_v`

	v = 11; // assignment to `v`
	*ptr_v = 12;
	ref_v = 13; // assignment to `ref_v`
	v = v + 1; // assignment to `v`
	v += 1;
	v++;
}

class myClass1
{
public:
	myClass1(float _x, float _y = 0.0f) : x(_x), y(_y), z(0.0f) { // assignments to `_y`, `x`, `y`, `z`
		// ...
	}

private:
	float x, y, z;
};

// ---

struct myStruct1
{
	int num;
	const char *str;
};

myStruct1 v1 = {1, "One"}; // assigment to `v1`
myStruct1 v2 = {.num = 2, .str = "Two"}; // assigment to `v2`

void test2(myStruct1 v = {3, "Three"}) // assignment to `v` (literal `{...}` has no location)
{
	// ...
}

struct myStruct2
{
	myStruct1 ms2;
};

myStruct2 v3 = {{4, "Four"}}; // assigment to `v3`

// ---

int myArray[10] = {1, 2, 3}; // assigment to `myArray`
char chars1[] = "abc"; // assignment to `chars1` (literal "abc" has no location)
char chars2[] = {'a', 'b', 'c'}; // assigment to `chars2`
char *chars3 = "abc"; // assigment to `chars3`
