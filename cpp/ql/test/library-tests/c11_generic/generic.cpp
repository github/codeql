// semmle-extractor-options: --clang -std=c++11
// The C11 _Generic keyword is supported in C++ mode in clang >= 4.0.0.

int printf(const char *format, ...);

#define describe(val) \
	_Generic((val), \
		int: "int", \
		const char *: "string", \
		default: "unknown" \
	)

typedef int MYINT;

int main()
{
	int i;
	MYINT m;
	const char *s;
	float ***f;

	printf("i is %s\n", describe(i)); // int
	printf("c is %s\n", describe(m)); // int
	printf("s is %s\n", describe(s)); // string
	printf("f is %s\n", describe(f)); // unknown
}
