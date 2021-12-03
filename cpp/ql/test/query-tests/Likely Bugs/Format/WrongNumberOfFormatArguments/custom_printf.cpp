
#define NULL (0)
#define va_list void *
#define va_start(x, y)
#define va_end(x)

int vsprintf(char *s, const char *format, va_list arg);

class myClass
{
public:
	void myPrintf(const char *format, ...) __attribute__((format(printf, 2, 3)));
};

void myClass :: myPrintf(const char *format, ...)
{
	char buffer[4096];
	if (!format) return;
	va_list args;
	va_start(args, format);
	vsprintf(buffer, format, args);
	va_end(args);
}

void test_custom_printf()
{
	myClass mc;

	mc.myPrintf("%i%i", 1); // BAD (too few format arguments)
	mc.myPrintf("%i%i", 1, 2); // GOOD
	mc.myPrintf("%i%i", 1, 2, 3); // BAD (too many format arguments)
	mc.myPrintf(NULL, 1, 2, 3); // GOOD (should not be analyzed)
}

void printf(char *notTheFormat, char *format, ...) // (not a recognizable format function)
{
	// ...
}

void test_custom_printf2()
{
	//     notTheFormat  format    ...
	printf(0,            "%i %i",  100, 200); // GOOD
	printf("",           "%i %i",  100, 200); // GOOD
	printf("%i %i",      ""        );         // GOOD
}
