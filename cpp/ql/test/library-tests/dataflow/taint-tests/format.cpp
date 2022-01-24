
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
	int result;

	va_list args;
	va_start(args, format);
		result = vsnprintf(s, n, format, args);
	va_end(args);

	return result;
}

int sscanf(const char *s, const char *format, ...);

// ----------

int source();
void sink(...);

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
		sink(buffer); // $ ast,ir
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, string::source(), "Hello."));
		sink(buffer); // $ ast,ir
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%s %s %s", "a", "b", string::source()));
		sink(buffer); // $ ast,ir
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%.*s", 10, string::source()));
		sink(buffer); // $ ast,ir
	}

	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%i", 0));
		sink(buffer);
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%i", source()));
		sink(buffer); // $ ast,ir
	}
	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%.*s", source(), "Hello."));
		sink(buffer); // $ ast,ir
	}

	{
		char buffer[256] = {0};
		sink(snprintf(buffer, 256, "%p", string::source()));
		sink(buffer); // $ ast,ir // tainted (debatable)
	}

	{
		char buffer[256] = {0};
		sink(sprintf(buffer, "%s", string::source()));
		sink(buffer); // $ ast,ir
	}
	{
		char buffer[256] = {0};
		sink(sprintf(buffer, "%ls", wstring::source()));
		sink(buffer); // $ ast,ir
	}
	{
		wchar_t wbuffer[256] = {0};
		sink(swprintf(wbuffer, 256, L"%s", wstring::source()));
		sink(wbuffer); // $ ast,ir
	}
	{
		char buffer[256] = {0};
		sink(mysprintf(buffer, 256, "%s", string::source()));
		sink(buffer); // $ ast,ir
	}

	{
		int i = 0;
		sink(sscanf("123", "%i", &i));
		sink(i);
	}
	{
		int i = 0;
		sink(sscanf(string::source(), "%i", &i));
		sink(i); // $ ast,ir
	}
	{
		char buffer[256] = {0};
		sink(sscanf("Hello.", "%s", &buffer));
		sink(buffer);
	}
	{
		char buffer[256] = {0};
		sink(sscanf(string::source(), "%s", &buffer));
		sink(buffer); // $ ast,ir
	}
}

// ----------

size_t strlen(const char *s);
size_t wcslen(const wchar_t *s);

void test2()
{
	char *s = string::source();
	wchar_t *ws = wstring::source();
	int i;

	sink(strlen(s));
	sink(wcslen(ws));

	i = strlen(s) + 1;
	sink(i);

	sink(s[strlen(s) - 1]); // $ ast,ir
	sink(ws + (wcslen(ws) / 2)); // $ ast,ir
}
