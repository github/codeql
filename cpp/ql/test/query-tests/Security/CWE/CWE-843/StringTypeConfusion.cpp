#define NULL 0
#define CONST               const
typedef wchar_t WCHAR;    // wc,   16-bit UNICODE character
typedef char CHAR;

typedef WCHAR *LPWSTR;
typedef CONST WCHAR *LPCWSTR;

typedef CHAR *LPSTR;
typedef CONST CHAR *LPCSTR;

void fconstChar(LPCSTR p) {}
void fChar(LPSTR p) {}
void fconstWChar(LPCWSTR p) {}
void fWChar(LPWSTR p) {}

void Test()
{
	char *lpChar = NULL;
	wchar_t *lpWchar = NULL;

	lpChar = (LPSTR)L"a"; // BUG
	lpWchar = (LPWSTR)"a"; // BUG

	lpChar = (char*)lpWchar;	// BUG
	lpWchar = (wchar_t*)lpChar;	// BUG

	fconstChar((LPCSTR)lpWchar);	// BUG
	fChar((LPSTR)lpWchar);			// BUG
	fconstWChar((LPCWSTR)lpChar);	// BUG
	fWChar((LPWSTR)lpChar);			// BUG

	lpChar = (LPSTR)"a"; // Valid
	lpWchar = (LPWSTR)L"a"; // Valid

	fconstChar((LPCSTR)lpChar);		// Valid
	fChar(lpChar);					// Valid
	fconstWChar((LPCWSTR)lpWchar);	// Valid
	fWChar(lpWchar);				// Valid
}