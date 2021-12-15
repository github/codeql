void report(void *p) { }

void use_parameter_address(int *x)
{
	int **y = &x;
	report(*y);
}

void use_parameter_address_and_value(int *xv)
{
	int **addr = &xv;
	report(*addr);
	report(xv);
}

void use_parameter_value(int *v)
{
	report(v);
}

void use1(void)
{
	int a;
	int *b = &a;
	use_parameter_address(b);
	use_parameter_value(b);
	report(b);
}

void use2(void)
{
	int c;
	int *d = &c;
	use_parameter_address(d);
	use_parameter_address_and_value(d);
	use_parameter_value(d);
	report(d);
}

void use3(void)
{
	int e;
	int *f = &e;
	use_parameter_address_and_value(f);
	use_parameter_value(f);
	report(f);
}

int main(int argc, char **argv)
{
	use1();
	use2();
	use3();
	return 0;
}
