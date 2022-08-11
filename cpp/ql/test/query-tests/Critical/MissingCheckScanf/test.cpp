typedef struct {} FILE;

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

		scanf("%d", &i); // BAD: may not have written `i`
		use(i);
	}

	{
		int i;

		if (scanf("%d", &i) == 1) // GOOD: checks return value
		{
			use(i);
		}
	}

	{
		int i = 0;

		scanf("%d", &i); // BAD. Design choice: already initialized variables shouldn't make a difference.
		use(i);
	}

	{
		int i;
		use(i);

		if (scanf("%d", &i) == 1) // GOOD: only care about uses after scanf call
		{
			use(i);
		}
	}

	{
		int i; // Reused variable

		scanf("%d", &i); // BAD
		use(i);

		if (scanf("%d", &i) == 1) // GOOD
		{
			use(i);
		}
	}

	// --- different scanf functions ---

	{
		int i;

		fscanf(get_a_stream(), "%d", &i); // BAD: may not have written `i`
		use(i);
	}

	{
		int i;

		sscanf(get_a_string(), "%d", &i); // BAD: may not have written `i`
		use(i);
	}

	// --- different ways of checking ---

	{
		int i;

		if (scanf("%d", &i) >= 1) // GOOD
		{
			use(i);
		}
	}

	{
		int i;

		if (scanf("%d", &i) == 1) // GOOD
		{
			use(i);
		}
	}

	{
		int i;

		if (scanf("%d", &i) != 0) // BAD: scanf can return -1 [NOT DETECTED]
		{
			use(i);
		}
	}

	{
		int i;

		if (scanf("%d", &i) == 0) // BAD: checks return value incorrectly [NOT DETECTED]
		{
			use(i);
		}
	}

	{
		int r;
		int i;

		r = scanf("%d", &i); // GOOD

		if (r >= 1)
		{
			use(i);
		}
	}

	{
		bool b;
		int i;

		b = scanf("%d", &i); // BAD [NOT DETECTED]: scanf can return EOF (boolifies true)

		if (b >= 1)
		{
			use(i);
		}
	}

	{
		bool b;
		int i;

		b = scanf("%d", &i); // BAD [NOT DETECTED]

		use(i);
	}

	{
		int i, j;

		if (scanf("%d %d", &i) >= 2) // GOOD: `j` is not a scanf arg, so out of scope of MissingCheckScanf
		{
			use(i);
			use(j);
		}
	}

	{
		int i, j;

		if (scanf("%d %d", &i, &j) >= 1) // BAD: checks return value incorrectly [NOT DETECTED]
		{
			use(i);
			use(j);
		}
	}

	// --- different initialization ---

	{
		int i;
		i = 0;

		scanf("%d", &i); // BAD
		use(i);
	}

	{
		int i;

		set_by_ref(i);
		scanf("%d", &i); // BAD
		use(i);
	}

	{
		int i;

		set_by_ptr(&i);
		scanf("%d", &i); // BAD
		use(i);
	}

	{
		int i;

		if (maybe())
		{
			i = 0;
		}

		scanf("%d", &i); // BAD: `i` may not have been initialized
		use(i);
	}

	// --- different use ---

	{
		int i;
		int *ptr_i = &i;

		scanf("%d", &i); // BAD: may not have written `i`
		use(*ptr_i);
	}

	// --- weird formatting strings ---

	{
		int i;

		if (scanf("%n %d", &i) >= 1) // GOOD (`%n` does not consume input)
		{
			use(i);
		}
	}

	{
		int i;

		if (scanf("%% %d", &i) >= 1) // GOOD (`%%` does not consume input)
		{
			use(i);
		}
	}

	{
		int i;

		if (scanf("%*d %d", &i) >= 1) // GOOD (`%*d` does not consume input)
		{
			use(i);
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

	my_scan_int(i); // BAD [NOT DETECTED]
	use(i);

	if (my_scan_int(i)) // GOOD
	{
		use(i);
	}
}
