#define NULL 0
#define CONST               const
typedef wchar_t WCHAR;    // wc,   16-bit UNICODE character
typedef char CHAR;

typedef WCHAR *LPWSTR;
typedef CONST WCHAR *LPCWSTR;

typedef CHAR *LPSTR;
typedef CONST CHAR *LPCSTR;

void fconstWChar(LPCWSTR p) {}
void fWChar(LPWSTR p) {}

void Test()
{
	char *lpChar = NULL;
	wchar_t *lpWchar = NULL;
	LPCSTR lpcstr = "b";

	lpWchar = (LPWSTR)"a"; // $ Alert
	lpWchar = (LPWSTR)lpcstr; // $ Alert

	lpWchar = (wchar_t*)lpChar;	// $ Alert

	fconstWChar((LPCWSTR)lpChar);	// $ Alert
	fWChar((LPWSTR)lpChar);			// $ Alert

	lpChar = (LPSTR)"a"; // Valid
	lpWchar = (LPWSTR)L"a"; // Valid

	fconstWChar((LPCWSTR)lpWchar);	// Valid
	fWChar(lpWchar);				// Valid
}

void NewBufferFalsePositiveTest()
{
	wchar_t *lpWchar = NULL;

	lpWchar = (LPWSTR)new char[56]; // Possible False Positive
}

typedef unsigned char BYTE;
typedef BYTE* PBYTE;

void NonStringFalsePositiveTest1(PBYTE buffer)
{
	wchar_t *lpWchar = NULL;
	lpWchar = (LPWSTR)buffer; // Possible False Positive
}

void NonStringFalsePositiveTest2(unsigned char* buffer)
{
	wchar_t *lpWchar = NULL;
	lpWchar = (LPWSTR)buffer; // Possible False Positive
}

typedef unsigned char BYTE;
using FOO = BYTE*;

void NonStringFalsePositiveTest3(FOO buffer)
{
	wchar_t *lpWchar = NULL;
	lpWchar = (LPWSTR)buffer; // GOOD
}

#define UNICODE 0x8

// assume EMPTY_MACRO is tied to if UNICODE is enabled
#ifdef EMPTY_MACRO
typedef WCHAR* LPTSTR;
#else
typedef char* LPTSTR;
#endif

void CheckedConversionFalsePositiveTest3(unsigned short flags, LPTSTR buffer)
{
	wchar_t *lpWchar = NULL;
	if(flags & UNICODE)
		lpWchar = (LPWSTR)buffer; // GOOD
	else
		lpWchar = (LPWSTR)buffer; // $ Alert

	if((flags & UNICODE) == 0x8)
		lpWchar = (LPWSTR)buffer; // GOOD
	else
		lpWchar = (LPWSTR)buffer; // $ Alert

	if((flags & UNICODE) != 0x8)
		lpWchar = (LPWSTR)buffer; // $ Alert
	else
		lpWchar = (LPWSTR)buffer; // GOOD

	// Bad operator precedence
	if(flags & UNICODE == 0x8)
		lpWchar = (LPWSTR)buffer; // $ Alert
	else
		lpWchar = (LPWSTR)buffer; // $ Alert

	if((flags & UNICODE) != 0)
		lpWchar = (LPWSTR)buffer; // GOOD
	else
		lpWchar = (LPWSTR)buffer; // $ Alert

	if((flags & UNICODE) == 0)
		lpWchar = (LPWSTR)buffer; // $ Alert
	else
		lpWchar = (LPWSTR)buffer; // GOOD

	lpWchar = (LPWSTR)buffer; // $ Alert
}

typedef unsigned long long size_t;

size_t wcslen(const wchar_t *str);
size_t strlen(const char* str);

template<typename C>
size_t str_len(const C *str) {
	if (sizeof(C) != 1) {
		return wcslen((const wchar_t *)str); // GOOD -- unreachable code
	}

	return strlen((const char *)str);
}

template<typename C>
size_t wrong_str_len(const C *str) {
	if (sizeof(C) == 1) {
		return wcslen((const wchar_t *)str); // $ Alert
	}

	return strlen((const char *)str);
}

void test_str_len(const wchar_t *wstr, const char *str) {
	size_t len =
	  str_len(wstr) + 
	  str_len(str) +
	  wrong_str_len(wstr) +
	  wrong_str_len(str);
}
