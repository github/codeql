
typedef unsigned long size_t;
typedef struct {} FILE;

int snprintf(char *s, size_t n, const char *format, ...);
int sprintf(char *s, const char *format, ...);
int swprintf(wchar_t *s, size_t n, const wchar_t *format, ...);

typedef void *va_list;
#define va_start(ap, parmN)
#define va_end(ap)
#define va_arg(ap, type) ((type)0)

int vsnprintf(char *s, size_t n, const char *format, va_list arg);

int mysprintf(char *s, size_t n, const char *format, ...)
{


	va_list args;
	va_start(args, format);
		vsnprintf(s, n, format, args);
	va_end(args);


}

int sscanf(const char *s, const char *format, ...);

// ----------

int source();
void sink(...) {};

namespace string
{
	char *source();
};

namespace wstring
{
	wchar_t *source();
};

// ----------

void test1()
{
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%s", "Hello."));
		sink(buffer);
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%s", string::source()));
		sink(buffer); // tainted
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, string::source(), "Hello."));
		sink(buffer); // tainted
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%s %s %s", "a", "b", string::source()));
		sink(buffer); // tainted
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%.*s", 10, string::source()));
		sink(buffer); // tainted
	}

	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%i", 0));
		sink(buffer);
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%i", source()));
		sink(buffer); // tainted
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%.*s", source(), "Hello."));
		sink(buffer); // tainted
	}

	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%p", string::source()));
		sink(buffer); // tainted (debatable)
	}

	{
		char buffer[256] = {0};
		sink(sprintf(buffer, "%s", string::source()));
		sink(buffer); // tainted
	}
	{
		char buffer[256] = {0};
		sink(sprintf(buffer, "%ls", wstring::source()));
		sink(buffer); // tainted
	}
	{
		wchar_t wbuffer[256] = {0};
		sink(swprintf(wbuffer, 256, L"%s", wstring::source()));
		sink(wbuffer); // tainted
	}
	{
		char buffer[256] = {0};
		sink(mysprintf(buffer, 256, "%s", string::source()));
		sink(buffer); // tainted [NOT DETECTED - implement UserDefinedFormattingFunction.getOutputParameterIndex()]
	}

	{
		int i = 0;
		sink(sscanf("123", "%i", &i));
		sink(i);
	}
	{
		int i = 0;
		sink(sscanf(string::source(), "%i", &i));
		sink(i); // tainted [NOT DETECTED]
	}
	{
		char buffer[256] = {0};
		sink(sscanf("Hello.", "%s", &buffer));
		sink(buffer);
	}
	{
		char buffer[256] = {0};
		sink(sscanf(string::source(), "%s", &buffer));
		sink(buffer); // tainted [NOT DETECTED]
	}
}
