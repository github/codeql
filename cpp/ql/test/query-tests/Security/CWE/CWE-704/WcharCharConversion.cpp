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