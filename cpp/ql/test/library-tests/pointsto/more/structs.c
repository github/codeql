// pointsto on structs

typedef struct
{
	int *ptr;
} myStruct;

int *myFunction()
{
	int x, y, z;
	myStruct a, b;
	int *zp;
	
	a.ptr = &x;
	b.ptr = &y;
	zp = &z;

	return a.ptr; // &x [FALSE POSITIVE: y]
}
