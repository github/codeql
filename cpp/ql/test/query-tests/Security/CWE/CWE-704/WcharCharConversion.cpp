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

	lpWchar = (LPWSTR)"a"; // BUG
	lpWchar = (LPWSTR)lpcstr; // BUG

	lpWchar = (wchar_t*)lpChar;	// BUG

	fconstWChar((LPCWSTR)lpChar);	// BUG
	fWChar((LPWSTR)lpChar);			// BUG

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
		lpWchar = (LPWSTR)buffer; // BUG

	if((flags & UNICODE) == 0x8)
		lpWchar = (LPWSTR)buffer; // GOOD
	else
		lpWchar = (LPWSTR)buffer; // BUG

	if((flags & UNICODE) != 0x8)
		lpWchar = (LPWSTR)buffer; // BUG
	else
		lpWchar = (LPWSTR)buffer; // GOOD

	// Bad operator precedence
	if(flags & UNICODE == 0x8)
		lpWchar = (LPWSTR)buffer; // BUG
	else
		lpWchar = (LPWSTR)buffer; // BUG

	if((flags & UNICODE) != 0)
		lpWchar = (LPWSTR)buffer; // GOOD
	else
		lpWchar = (LPWSTR)buffer; // BUG

	if((flags & UNICODE) == 0)
		lpWchar = (LPWSTR)buffer; // BUG
	else
		lpWchar = (LPWSTR)buffer; // GOOD

	lpWchar = (LPWSTR)buffer; // BUG
}
