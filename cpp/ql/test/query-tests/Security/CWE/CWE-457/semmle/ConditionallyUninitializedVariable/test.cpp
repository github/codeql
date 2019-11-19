
void use(int i);

int maybeInitialize1(int *v)
{
	static int resources = 100;

	if (resources == 0)
	{
		return 0; // FAIL
	}

	*v = resources--;
	return 1; // SUCCESS
}

void test1()
{
	int a, b, c, d, e, f;
	int result1, result2;

	maybeInitialize1(&a); // BAD (initialization not checked)
	use(a);
	
	if (maybeInitialize1(&b) == 1) // GOOD
	{
		use(b);
	}
	
	if (maybeInitialize1(&c) == 0) // BAD (initialization check is wrong) [NOT DETECTED]
	{
		use(c);
	}

	result1 = maybeInitialize1(&d); // BAD (initialization stored but not checked) [NOT DETECTED]
	use(d);

	result2 = maybeInitialize1(&e); // GOOD
	if (result2 == 1)
	{
		use(e);
	}

	if (maybeInitialize1(&f) == 0) // GOOD
	{
		return;
	}
	use(f);
}

bool maybeInitialize2(int *v)
{
	static int resources = 100;

	if (resources > 0)
	{
		*v = resources--;
		return true; // SUCCESS
	}

	return false; // FAIL
}

void test2()
{
	int a, b;

	maybeInitialize2(&a); // BAD (initialization not checked)
	use(a);
	
	if (maybeInitialize2(&b)) // GOOD
	{
		use(b);
	}
}

int alwaysInitialize(int *v)
{
	static int resources = 0;

	*v = resources++;
	return 1; // SUCCESS
}

void test3()
{
	int a, b;

	alwaysInitialize(&a); // GOOD (initialization never fails)
	use(a);
	
	if (alwaysInitialize(&b) == 1) // GOOD
	{
		use(b);
	}
}
