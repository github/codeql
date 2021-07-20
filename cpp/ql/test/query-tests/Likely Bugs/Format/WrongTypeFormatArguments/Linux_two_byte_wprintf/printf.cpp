/*
 * Test for custom definitions of *wprintf using different types than the
 * platform wide character type.
 */

#define WCHAR char16_t
typedef void *va_list;
#define va_start(va, other)
#define va_end(args)

int	vswprintf(WCHAR *dest, WCHAR *format, va_list args);

int swprintf(WCHAR *dest, WCHAR *format, ...) {
	va_list args;
	va_start(args, format);

	int ret = vswprintf(dest, format, args);

	va_end(args);

	return ret;
}

int sprintf(char *dest, char *format, ...);

// ---

void test1() {
	WCHAR string[20];

	swprintf(string, u"test %s", u"test"); // BAD: `char16_t` string parameter read as `char` string [NOT DETECTED; correct on Microsoft platforms]
}

void test2() {
	char string[20];

	sprintf(string, "test %S", u"test"); // GOOD
}

void test3() {
	char string[20];

	sprintf(string, "test %s", u"test"); // BAD: `char16_t` string parameter read as `char` string
}


void test4() {
	char string[20];

	sprintf(string, "test %S", L"test"); // BAD: `wchar_t` string parameter read as `char16_t` string
}
