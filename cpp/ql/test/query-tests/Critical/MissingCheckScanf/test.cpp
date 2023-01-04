typedef struct
{
} FILE;

typedef void *locale_t;

int scanf(const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
int sscanf(const char *s, const char *format, ...);
int _scanf_l(const char *format, locale_t locale, ...);

void use(int i);

void set_by_ref(int &i);
void set_by_ptr(int *i);
bool maybe();

FILE *get_a_stream();
const char *get_a_string();
extern locale_t get_a_locale();

typedef long size_t;

void *malloc(size_t size);
void free(void *ptr);

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

	{
		int i; // Reset variable

		scanf("%d", &i);
		use(i); // BAD

		i = 1;
		use(i); // GOOD
	}

	{
		int *i = (int*)malloc(sizeof(int)); // Allocated variable

		scanf("%d", i);
		use(*i); // BAD
		free(i); // GOOD
	}

	{
		int *i = new int; // Allocated variable

		scanf("%d", i);
		use(*i); // BAD
		delete i; // GOOD
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

	{
		int i;

		if (_scanf_l("%d", get_a_locale(), &i) == 1)
		{
			use(i); // GOOD
		}
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
			use(i); // BAD: scanf can return EOF
		}
	}

	{
		int i;

		if (scanf("%d", &i) == 0)
		{
			use(i); // BAD: checks return value incorrectly
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
		int i;

		if (scanf("%d", &i))
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
			use(j); // BAD: checks return value incorrectly
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

	{
		char c[5];
		int d;

		while(maybe()) {
			if (maybe()) {
				break;
			}
			else if (maybe() && (scanf("%5c %d", c, &d) == 1)) { // GOOD
				use(*(int *)c); // GOOD
				use(d); // BAD
			}
			else if ((scanf("%5c %d", c, &d) == 1) && maybe()) { // GOOD
				use(*(int *)c); // GOOD
				use(d); // BAD
			}
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
		int i, j;

		if (sscanf("123", "%n %*d %n", &i, &j) >= 0)
		{
			use(i); // GOOD (`%n` does not consume input, but writes 0 to i)
			use(j); // GOOD (`%n` does not consume input, but writes 3 to j)
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

	{
		int d, n;

		if (scanf("%*d %d %n", &d, &n) == 1) {
			use(d); // GOOD
			use(n); // GOOD
		}
	}

	{
		char substr[32];
		int n;
        while (sscanf(get_a_string(), "%31[^:]: %d", substr, &n) == 2) { // GOOD: cycle from write to unguarded access
			use(*(int *)substr); // GOOD
            use(n); // GOOD
		}
	}
}

// --- Non-local cases ---

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

// --- Can be OK'd given a sufficiently smart analysis ---

char *my_string_copy() {
	static const char SRC_STRING[] = "48656C6C6F";
	static       char DST_STRING[] = ".....";

	int len = sizeof(SRC_STRING) - 1;
    const char *src = SRC_STRING;
    char *ptr = DST_STRING;

    for (int i = 0; i < len; i += 2) {
		unsigned int u;
	    sscanf(src + i, "%2x", &u);
        *ptr++ = (char) u; // GOOD [FALSE POSITIVE]? src+i+{0,1} are always valid %x digits, so this should be OK.
    }
	*ptr++ = 0;
	return DST_STRING;
}
