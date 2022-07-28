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

		scanf("%d", &i); // BAD
		use(i);
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
		bool b;
		int i;

		b = scanf("%d", &i); // GOOD

		if (b >= 1)
		{
			use(i);
		}
	}

	{
		int i, j;

		if (scanf("%d %d", &i) >= 2) // GOOD
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
