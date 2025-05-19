#define CONST               const

typedef unsigned long       DWORD;
typedef int                 BOOL;
typedef unsigned char       BYTE;
typedef unsigned long ULONG_PTR;
typedef unsigned long *PULONG_PTR;
typedef wchar_t WCHAR;    // wc,   16-bit UNICODE character
typedef void *PVOID;
typedef CONST WCHAR *LPCWSTR, *PCWSTR;
typedef PVOID BCRYPT_ALG_HANDLE;
typedef long LONG;
typedef unsigned long ULONG;
typedef ULONG *PULONG;
typedef LONG NTSTATUS;
typedef ULONG_PTR HCRYPTHASH;
typedef ULONG_PTR HCRYPTPROV;
typedef ULONG_PTR HCRYPTKEY;
typedef ULONG_PTR HCRYPTHASH;
typedef unsigned int ALG_ID;
typedef PVOID BCRYPT_HANDLE;
typedef unsigned char UCHAR;
typedef UCHAR *PUCHAR;

// Property Strings
#define BCRYPT_CHAIN_MODE_NA        L"ChainingModeN/A"
#define BCRYPT_CHAIN_MODE_CBC       L"ChainingModeCBC"
#define BCRYPT_CHAIN_MODE_ECB       L"ChainingModeECB"
#define BCRYPT_CHAIN_MODE_CFB       L"ChainingModeCFB"
#define BCRYPT_CHAIN_MODE_CCM       L"ChainingModeCCM"
#define BCRYPT_CHAIN_MODE_GCM       L"ChainingModeGCM"

#define BCRYPT_CHAINING_MODE        L"ChainingMode"
#define BCRYPT_PADDING_SCHEMES      L"PaddingSchemes"

NTSTATUS
BCryptSetProperty(
	BCRYPT_HANDLE   hObject,
	LPCWSTR pszProperty,
	PUCHAR   pbInput,
	ULONG   cbInput,
	ULONG   dwFlags);

NTSTATUS
AnyFunctionName(
	BCRYPT_HANDLE   hObject,
	LPCWSTR pszProperty,
	PUCHAR   pbInput,
	ULONG   cbInput,
	ULONG   dwFlags);

void
DummyFunction(
	LPCWSTR pszProperty,
	LPCWSTR pszMode)
{
	BCryptSetProperty(0, pszProperty, (PUCHAR)&pszMode, 0, 0);
}


// Macro testing
#define MACRO_INVOCATION_SETKPMODE(p) { LPCWSTR pszMode = p; \
		BCryptSetProperty(0, BCRYPT_CHAINING_MODE, (PUCHAR)&pszMode, 0, 0); }

int main()
{
	LPCWSTR val = 0;
	////////////////////////////
	// Should fire an event
	val = BCRYPT_CHAIN_MODE_NA;
	BCryptSetProperty(0, BCRYPT_CHAINING_MODE, (PUCHAR)&val, 0, 0);
	val = BCRYPT_CHAIN_MODE_ECB;
	BCryptSetProperty(0, BCRYPT_CHAINING_MODE, (PUCHAR)&val, 0, 0);
	val = BCRYPT_CHAIN_MODE_CFB;
	BCryptSetProperty(0, BCRYPT_CHAINING_MODE, (PUCHAR)&val, 0, 0);
	val = BCRYPT_CHAIN_MODE_CCM;
	BCryptSetProperty(0, BCRYPT_CHAINING_MODE, (PUCHAR)&val, 0, 0);
	val = BCRYPT_CHAIN_MODE_GCM;
	BCryptSetProperty(0, BCRYPT_CHAINING_MODE, (PUCHAR)&val, 0, 0);
	val = L"ChainingModeNEW";
	BCryptSetProperty(0, BCRYPT_CHAINING_MODE, (PUCHAR)&val, 0, 0);
	DummyFunction(BCRYPT_CHAINING_MODE, BCRYPT_CHAIN_MODE_GCM);
	MACRO_INVOCATION_SETKPMODE(BCRYPT_CHAIN_MODE_ECB)

	////////////////////////////
	// Should not fire an event
	val = BCRYPT_CHAIN_MODE_CBC;
	BCryptSetProperty(0, BCRYPT_CHAINING_MODE, (PUCHAR)&val, 0, 0);
	val = BCRYPT_CHAIN_MODE_ECB;
	BCryptSetProperty(0, BCRYPT_PADDING_SCHEMES, (PUCHAR)&val, 0, 0);
	val = BCRYPT_CHAIN_MODE_ECB;
	AnyFunctionName(0, BCRYPT_CHAINING_MODE, (PUCHAR)&val, 0, 0);
}