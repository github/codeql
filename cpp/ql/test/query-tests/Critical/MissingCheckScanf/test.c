# define likely(x)	__builtin_expect(!!(x), 1)
int sscanf(const char *s, const char *format, ...);

void use(int i);

void test_likely(const char* s, const char* format)
{
	int x;

	if (likely(sscanf(s, format, &x) == 1)) {
		use(x); // GOOD
  }
}