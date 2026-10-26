// semmle-extractor-options: --microsoft

char *Xstrdup(const char *string);
void abort();
struct FILE;
char *fgets(char *str, int num, FILE *stream);
int ignore_return_value();
#define IGNORE_RETURN_VALUE() ignore_return_value()
void myIgnoreReturnValue();

static int f(int argc, char *argv[])
{
	char *s1 = Xstrdup("Hello, world!");
	char *s2 = Xstrdup(0);

	if (argc == 0)
	{
		abort();
	} else if (argc == 1) {
		__assume(0);
	}

	{
		char buffer[256];
		char *result;
		FILE *s;
	
		result = fgets(buffer, 256, s);
	}
	
	IGNORE_RETURN_VALUE();

	myIgnoreReturnValue();
}
