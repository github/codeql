/*
 * Test for custom definitions of *wprintf using different types than the
 * platform wide character type.
 */

typedef unsigned int size_t;

int printf(const char * format, ...);
int wprintf(const wchar_t * format, ...); // on wchar_t
int swprintf(char16_t * s, size_t n, const char16_t * format, ...); // on char16_t

#define BUF_SIZE (4096)

void tests() {
	char16_t buffer[BUF_SIZE];

	printf("%s", "Hello"); // GOOD
	printf("%s", u"Hello"); // BAD: expecting char
	printf("%s", L"Hello"); // BAD: expecting char

	printf("%S", "Hello"); // BAD: expecting wchar_t or char16_t
	printf("%S", u"Hello"); // GOOD
	printf("%S", L"Hello"); // GOOD

	wprintf(L"%s", "Hello"); // GOOD
	wprintf(L"%s", u"Hello"); // BAD: expecting char
	wprintf(L"%s", L"Hello"); // BAD: expecting char [NOT DETECTED; correct on Microsoft platforms]

	wprintf(L"%S", "Hello"); // BAD: expecting wchar_t [NOT DETECTED; correct on Microsoft platforms]
	wprintf(L"%S", u"Hello"); // BAD: expecting wchar_t
	wprintf(L"%S", L"Hello"); // GOOD

	swprintf(buffer, BUF_SIZE, u"%s", "Hello"); // GOOD
	swprintf(buffer, BUF_SIZE, u"%s", u"Hello"); // BAD: expecting char [NOT DETECTED; correct on Microsoft platforms]
	swprintf(buffer, BUF_SIZE, u"%s", L"Hello"); // BAD: expecting char

	swprintf(buffer, BUF_SIZE, u"%S", "Hello"); // BAD: expecting char16_t [NOT DETECTED; correct on Microsoft platforms]
	swprintf(buffer, BUF_SIZE, u"%S", u"Hello"); // GOOD
	swprintf(buffer, BUF_SIZE, u"%S", L"Hello"); // BAD: expecting char16_t

	swprintf(buffer, BUF_SIZE, u"%hs", "Hello"); // GOOD
	swprintf(buffer, BUF_SIZE, u"%hs", u"Hello"); // BAD: expecting char
	swprintf(buffer, BUF_SIZE, u"%hs", L"Hello"); // BAD: expecting char

	swprintf(buffer, BUF_SIZE, u"%ls", "Hello"); // BAD: expecting char16_t
	swprintf(buffer, BUF_SIZE, u"%ls", u"Hello"); // GOOD
	swprintf(buffer, BUF_SIZE, u"%ls", L"Hello"); // BAD: expecting char16_t
}
