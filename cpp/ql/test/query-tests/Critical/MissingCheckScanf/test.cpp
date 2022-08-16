typedef struct
{
} FILE;

int scanf(const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
int sscanf(const char *s, const char *format, ...);

void use(int i);

void set_by_ref(int &i);
void set_by_ptr(int *i);
bool maybe();

FILE *get_a_stream();
const char *get_a_string();

int main()
{
	// --- simple cases ---

	{
		int i;

		scanf("%d", &i);
		use(i); // BAD: may not have written `i`
	}

	{
		int i;

		if (scanf("%d", &i) == 1)
		{
			use(i); // GOOD: checks return value
		}
	}

	{
		int i = 0;

		scanf("%d", &i);
		use(i); // BAD. Design choice: already initialized variables shouldn't make a difference.
	}

	{
		int i;
		use(i); // GOOD: only care about uses after scanf call

		if (scanf("%d", &i) == 1)
		{
			use(i); // GOOD
		}
	}

	{
		int i; // Reused variable

		scanf("%d", &i);
		use(i); // BAD

		if (scanf("%d", &i) == 1)
		{
			use(i); // GOOD
		}
	}

	// --- different scanf functions ---

	{
		int i;

		fscanf(get_a_stream(), "%d", &i);
		use(i); // BAD: may not have written `i`
	}

	{
		int i;

		sscanf(get_a_string(), "%d", &i);
		use(i); // BAD: may not have written `i`
	}

	// --- different ways of checking ---

	{
		int i;

		if (scanf("%d", &i) >= 1)
		{
			use(i); // GOOD
		}
	}

	{
		int i;

		if (scanf("%d", &i) == 1)
		{
			use(i); // GOOD
		}
	}

	{
		int i;

		if (0 < scanf("%d", &i))
		{
			if (true)
			{
				use(i); // GOOD
			}
		}
	}

	{
		int i;

		if (scanf("%d", &i) != 0)
		{
			use(i); // BAD [NOT DETECTED]: scanf can return -1 (EOF)
		}
	}

	{
		int i;

		if (scanf("%d", &i) == 0)
		{
			use(i); // BAD [NOT DETECTED]: checks return value incorrectly
		}
	}

	{
		int r;
		int i;

		r = scanf("%d", &i);

		if (r >= 1)
		{
			use(i); // GOOD
		}
	}

	{
		bool b;
		int i;

		b = scanf("%d", &i);

		if (b >= 1)
		{
			use(i); // BAD [NOT DETECTED]: scanf can return EOF (boolifies true)
		}
	}

	{
		bool b;
		int i;

		b = scanf("%d", &i);

		if (b)
			use(i); // BAD
	}

	{
		int i, j;

		if (scanf("%d %d", &i) >= 2)
		{
			use(i); // GOOD
			use(j); // GOOD: `j` is not a scanf arg, so out of scope of MissingCheckScanf
		}
	}

	{
		int i, j;

		if (scanf("%d %d", &i, &j) >= 1)
		{
			use(i); // GOOD
			use(j); // BAD: checks return value incorrectly [NOT DETECTED]
		}
	}

	{
		int i, j;

		if (scanf("%d %d", &i, &j) >= 2)
		{
			use(i); // GOOD
			use(j); // GOOD
		}
	}

	// --- different initialization ---

	{
		int i;
		i = 0;

		scanf("%d", &i);
		use(i); // BAD
	}

	{
		int i;

		set_by_ref(i);
		scanf("%d", &i);
		use(i); // BAD
	}

	{
		int i;

		set_by_ptr(&i);
		scanf("%d", &i);
		use(i); // BAD
	}

	{
		int i;

		if (maybe())
		{
			i = 0;
		}

		scanf("%d", &i);
		use(i); // BAD: `i` may not have been initialized
	}

	// --- different use ---

	{
		int i;
		int *ptr_i = &i;

		scanf("%d", &i);
		use(*ptr_i); // BAD: may not have written `i`
	}

	{
		int i;
		int *ptr_i = &i;

		scanf("%d", ptr_i);
		use(i); // BAD: may not have written `*ptr_i`
	}

	{
		int i;
		scanf("%d", &i);
		i = 42;
		use(i); // GOOD
	}

	// --- weird formatting strings ---

	{
		int i;

		if (scanf("%n %d", &i) >= 1)
		{
			use(i); // GOOD (`%n` does not consume input)
		}
	}

	{
		int i;

		if (scanf("%% %d", &i) >= 1)
		{
			use(i); // GOOD (`%%` does not consume input)
		}
	}

	{
		int i;

		if (scanf("%*d %d", &i) >= 1)
		{
			use(i); // GOOD (`%*d` does not consume input)
		}
	}
}

// Non-local cases:

bool my_scan_int(int &i)
{
	return scanf("%d", &i) == 1; // GOOD
}

void my_scan_int_test()
{
	int i;

	use(i); // GOOD: used before scanf

	my_scan_int(i);
	use(i); // BAD [NOT DETECTED]

	if (my_scan_int(i))
	{
		use(i); // GOOD
	}
}
