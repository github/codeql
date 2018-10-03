

#define __INT32_TYPE__ int
#define __INTMAX_TYPE__ long int
typedef __INTMAX_TYPE__ intmax_t;
typedef __INT32_TYPE__ int32_t;

extern int fprintf(FILE *stream, const char *__fmt, ...);
extern struct _IO_FILE *stderr;

struct M {
	int32_t off;
};

int foo(struct M *m)
{
	{
		intmax_t off = m->off;

		fprintf(stderr, "indirect offs=%jd\n", off); // GOOD
	}
}

// --------------------------------------------------------------

#define MAX_LONGPATH 1024
#ifdef TEST_MICROSOFT
	typedef char16_t WCHAR;
#else
	typedef char32_t WCHAR;
#endif

void msg_out(const char *format, ...)
{
	va_list argp;
	va_start(argp, format);
	vprintf(format, argp);
	va_end(argp);
}

void someFunction()
{
	WCHAR filename[MAX_LONGPATH];
	int linenum;

	msg_out("Source file: %S @ %d\n", filename, linenum); // GOOD [FALSE POSITIVE]
}

// --------------------------------------------------------------

void bar()
{
	int i = 0;
	unsigned int ui = 0;
	signed int si = 0;
	short s = 0;

	printf("check %n", &i); // GOOD
	printf("check %n", &ui); // GOOD [dubious: int is written to unsigned int]
	printf("check %n", &si); // GOOD
	printf("check %n", &s); // BAD: int is written to short
	printf("check %hn", &i); // BAD: short is written to int
	printf("check %hn", &ui); // BAD: short is written to unsigned int
	printf("check %hn", &si); // BAD: short is written to signed int
	printf("check %hn", &s); // GOOD
}
