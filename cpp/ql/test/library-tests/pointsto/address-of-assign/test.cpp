int *a, **b, ***c;

extern void use(int *x, ...);

void f()
{
	c = &(b = &a);
	use(a, b, c);
}
