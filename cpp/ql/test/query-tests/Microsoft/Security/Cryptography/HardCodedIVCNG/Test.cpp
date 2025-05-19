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
typedef PVOID BCRYPT_KEY_HANDLE;
typedef long LONG;
typedef unsigned long ULONG;
typedef ULONG *PULONG;
typedef LONG NTSTATUS;
typedef ULONG_PTR HCRYPTHASH;
typedef ULONG_PTR HCRYPTPROV;
typedef ULONG_PTR HCRYPTKEY;
typedef ULONG_PTR HCRYPTHASH;
typedef unsigned int ALG_ID;

typedef unsigned char UCHAR; 
typedef UCHAR *PUCHAR;
#define VOID void

NTSTATUS
BCryptEncrypt(
	BCRYPT_KEY_HANDLE hKey,
	PUCHAR   pbInput,
	ULONG   cbInput,
	VOID    *pPaddingInfo,
	PUCHAR   pbIV,
	ULONG   cbIV,
	PUCHAR   pbOutput,
	ULONG   cbOutput,
	ULONG   *pcbResult,
	ULONG   dwFlags);


static unsigned long int next = 1;

int rand(void) // RAND_MAX assumed to be 32767
{
	next = next * 1103515245 + 12345;
	unsigned int tmp = (next / 65536) % 32768;
	if (tmp % next)
	{
		next = (next / 65526) % tmp;
	}
	return next;
}

int main()
{
	BYTE rgbIV[] =
	{
		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
		0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
	};

	BYTE* pIV = new BYTE(16);
	// rand() is not a good source for IV, 
	// but I am avoiding calling a CSPRGenerator for this test.
	for (int i = 0; i < 16; i++)
	{
		pIV[i] = (BYTE)rand();
	}

	BCryptEncrypt(0, 0, 0, 0, rgbIV, 16, 0, 0, 0, 0); // Must be flagged

	BCryptEncrypt(0, 0, 0, 0, pIV, 16, 0, 0, 0, 0); // Should not be flagged

	delete[] pIV;
}