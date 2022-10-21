/** standard printf functions */

int printf(const char *format, ...);

/** test program */

int main(int argc, char *argv[])
{
	long long int lli;
	double d;
	int i;

	// constant expressions
	printf("");
	printf("\x20");
	printf("\t");
	printf("%%");

	// characters
	printf("%c", 'a');
	printf("%c%c%c", 'a', 'b', 'c');

	// strings
	printf("Hello, world!");
	printf("%s", "Hello, world!");
	printf("%.4s", "Hello, world!");
	printf("%s, %s", "Hello", "world!");

	// integers
	printf("%i", i);
	printf("%lli", i);
	printf("%i", lli);
	printf("%lli", lli);
	printf("%d", i);
	printf("%u", i);
	printf("%x", i);
	printf("%X", i);
	printf("%#x", i);
	printf("%o", i);
	printf("%#o", i);

	// doubles
	printf("%f", d);
	printf("%.2f", d);
	printf("%e", d);

	return 0;
}

typedef long unsigned int size_t;
typedef unsigned int wint_t;

void more_cases(int a, int b)
{
	// integers
	{
		int i;

		printf("%Ii", i); // glibc 2.2 'I' prefix
	}

	// size_t
	{
		size_t st;

		printf("%zu", st); // size_t
		printf("%Zu", st); // non-standard synonym for 'z'
	}

	// wint_t
	{
		wint_t wt;

		printf("%lc", wt); // wide character
	}

	// posix indexed format arguments
	printf("%2$i, %1$i", 1, 2); // '2, 1'
	printf("%2$i, %1$i", a, b);
	
	printf("%2$02i %1$4.2f", 3.3333f, 6); // 06, 3.33
	{
		int width, num;

		printf("%2$*1$d", width, num);
		printf("%2$0*1$d", width, num);
	}
	{
		int precision;
		float num;

		printf("%2$.*1$f", precision, num);
	}

	// %%
	{
		float num;

		printf("#");
		printf("%%");
		printf("%%%%");
		printf("%%%f", num);
		printf("%%%%%f", num);
		printf("%4.2f%%", num);
		printf("%%%f%%", num);
	}

	// more tests of width and precision
	{
		float num;

		printf("%f", num);
		printf("%.1f", num);
		printf("%1f", num);
		printf("%1.1f", num);
		printf("%e", num);
		printf("%.2e", num);
		printf("%3e", num);
		printf("%3.2e", num);
		printf("%g", num);
		printf("%.1g", num);
		printf("%4g", num);
		printf("%4.1g", num);
	}
}
