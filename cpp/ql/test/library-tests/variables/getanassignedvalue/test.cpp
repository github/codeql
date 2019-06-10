
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
