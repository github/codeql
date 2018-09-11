void update(bool b);
void init(int &i);
bool cond(int i);
void update(int &i);

void test_while()
{
	bool b;

	b = true;
	while (b) update(b);

	do
	{
		update(b);
	} while (b);
}

void test_for()
{
	int i, j;

	for (i = 0; i < 10; i++) {
	}

	for (j = 10; j >= 0; ) j--;

	for (i = 0, j = 0; i < 10; i++, j++) {
	}

	for (init(i); cond(i); update(i)) {
	}

	for ((i = 100); (i >= 0); (i--)) {
	}
}
