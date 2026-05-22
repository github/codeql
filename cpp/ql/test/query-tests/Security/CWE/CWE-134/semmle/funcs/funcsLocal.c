// Semmle test case for rule UncontrolledFormatString.ql (Uncontrolled format string).
// Associated with CWE-134: Uncontrolled format string. http://cwe.mitre.org/data/definitions/134.html
// This file tests different ways to use the results of various function calls (that read information from the user) as an argument to printf.

int printf(const char *format, ...);
typedef unsigned long size_t;
typedef void FILE;
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
char *fgets(char *s, int n, FILE *stream);
char *gets(char *s);
FILE *f;

int main(int argc, char **argv) {
	// BAD: i1 comes from the user
	char i1[1024];
	fread(i1, sizeof(char), 1024, f);
	printf(i1);

	// GOOD: i2 comes from the user, but is not the format string here
	char i2[1024];
	fread(i2, sizeof(char), 1024, f);
	printf("%s", i2);

	// BAD: i3 comes from the user
	char i3[1024];
	fgets(i3, 1, 0);
	printf(i3);

	// BAD: i4 comes from the user
	char i41[1024];
	char *i4 = fgets(i41, 1, f);
	printf(i4);

	// BAD: i5 comes from the user
	char i5[1024];
	gets(i5);
	printf(i5);

	// BAD: i6 comes from the user
	char i61[1024];
	char *i6 = gets(i61);
	printf(i6);

	// BAD: i7 comes from the user
	char **i7;
	gets(*i7);
	printf(*i7);

	// BAD: i8 comes from the user
	char i81[1024];
	char **i8;
	*i8 = gets(i81);
	printf(*i8);

	// BAD: e1 comes from i1, which comes from the user
	char e1[1];
	e1[0] = i1[0];
	printf(e1);

	return 0;
}

typedef void *va_list;
typedef void *_locale_t;

int vprintf(const char *format, va_list argptr);
int _vprintf_l(const char *format, _locale_t locale, va_list argptr);

int vfprintf(FILE *stream, const char *format, va_list argptr);
int _vfprintf_l(FILE *stream, const char *format, _locale_t locale, va_list argptr);

int vsnprintf(char *buffer, size_t count, const char *format, va_list argptr);
int _vsnprintf(char *buffer, size_t count, const char *format, va_list argptr);
int _vsnprintf_l(char *buffer, size_t count, const char *format, _locale_t locale, va_list argptr);

int vsnprintf_s(
	char *buffer, size_t sizeOfBuffer, size_t count, const char *format, va_list argptr
);
int _vsnprintf_s(
	char *buffer, size_t sizeOfBuffer, size_t count, const char *format, va_list argptr
);
int _vsnprintf_s_l(
	char *buffer, size_t sizeOfBuffer, size_t count, const char *format, _locale_t locale,
	va_list argptr
);

int vsprintf(char *buffer, const char *format, va_list argptr);
int _vsprintf_l(char *buffer, const char *format, _locale_t locale, va_list argptr);

int _vsprintf_p(char *buffer, size_t sizeInBytes, const char *format, va_list argptr);
int _vsprintf_p_l(
	char *buffer, size_t sizeInBytes, const char *format, _locale_t locale, va_list argptr
);

int vsprintf_s(char *buffer, size_t numberOfElements, const char *format, va_list argptr);
int _vsprintf_s_l(
	char *buffer, size_t numberOfElements, const char *format, _locale_t locale, va_list argptr
);

int _vscprintf_p(const char *format, va_list argptr);
int _vscprintf_p_l(const char *format, _locale_t locale, va_list argptr);

void test() {
	// BAD: User input flowing to various printf-like functions.
	char fmt[1024];
	char out[1024];
	va_list args = 0;
	_locale_t locale = 0;
	fread(fmt, sizeof(char), 1024, f);
	vprintf(fmt, args); // MISSING: BAD
	_vprintf_l(fmt, locale, args); // MISSING: BAD
	vfprintf(f, fmt, args); // MISSING: BAD
	_vfprintf_l(f, fmt, locale, args); // MISSING: BAD
	vsnprintf(out, 1024, fmt, args); // MISSING: BAD
	_vsnprintf(out, 1024, fmt, args); // MISSING: BAD
	_vsnprintf_l(out, 1024, fmt, locale, args); // MISSING: BAD
	vsnprintf_s(out, 1024, 1024, fmt, args); // MISSING: BAD
	_vsnprintf_s(out, 1024, 1024, fmt, args); // MISSING: BAD
	_vsnprintf_s_l(out, 1024, 1024, fmt, locale, args); // MISSING: BAD
	vsprintf(out, fmt, args); // MISSING: BAD
	_vsprintf_l(out, fmt, locale, args); // MISSING: BAD
	_vsprintf_p(out, 1024, fmt, args); // MISSING: BAD
	_vsprintf_p_l(out, 1024, fmt, locale, args); // MISSING: BAD
	vsprintf_s(out, 1024, fmt, args); // MISSING: BAD
	_vsprintf_s_l(out, 1024, fmt, locale, args); // MISSING: BAD
	_vscprintf_p(fmt, args); // MISSING: BAD
	_vscprintf_p_l(fmt, locale, args); // MISSING: BAD
}