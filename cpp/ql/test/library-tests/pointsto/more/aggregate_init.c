// pointsto on aggregates

typedef struct
{
	int *ptr;
} myStruct1;

int *myFunction1()
{
	int x, y;
	myStruct1 a = { .ptr = &x };
	myStruct1 b = { .ptr = &y };

	return a.ptr; // &x [FALSE POSITIVE: y]
}
