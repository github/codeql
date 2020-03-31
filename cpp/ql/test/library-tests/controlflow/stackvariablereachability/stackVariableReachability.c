
int cond();
int f(int x);

void test(int p)
{
	int a = 10;
	int b = 20;
	int c = 30;

	a = a + 1;
	a = 40;
	a++;
	++a;
	a = f(a);
	a;

	if (cond()) {
		b = 50;
	} else {
		b = 60;
	}
	c = b;
	c;
}
