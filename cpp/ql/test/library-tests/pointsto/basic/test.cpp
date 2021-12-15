
typedef struct {
	int data[10];
} MyStruct;

MyStruct a, b, c, d;
MyStruct *p1, *p2, *p3;
MyStruct **pp1, **pp2;

void use(MyStruct v, ...);

void test(int cond)
{
	if (cond)
	{
		p1 = &a;
	} else {
		p1 = &b;
	}
	p2 = p1; // p1, p2 could point to a or b

	p3 = &c;
	pp1 = &p3;
	p3 = &d;
	pp2 = &p3; // pp1, pp2 point to p3; p3 could point to c or d (at different times)

	use(a, b, c, d, p1, p2, p3, pp1, pp2);
}
