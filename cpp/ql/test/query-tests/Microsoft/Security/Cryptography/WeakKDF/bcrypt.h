#define CONST               const

typedef unsigned long       DWORD;
typedef int                 BOOL;
typedef unsigned char       BYTE;
typedef unsigned long       ULONG_PTR;
typedef unsigned long       *PULONG_PTR;
typedef wchar_t             WCHAR;    // wc,   16-bit UNICODE character
typedef void                *PVOID;
typedef CONST WCHAR         *LPCWSTR, *PCWSTR;
typedef int                 BCRYPT_ALG_HANDLE;  // using int as a placeholder
typedef long                LONG;
typedef unsigned long       ULONG;
typedef ULONG               *PULONG;
typedef LONG                NTSTATUS;
typedef ULONG_PTR           HCRYPTHASH;
typedef ULONG_PTR           HCRYPTPROV;
typedef ULONG_PTR           HCRYPTKEY;
typedef ULONG_PTR           HCRYPTHASH;
typedef unsigned int        ALG_ID;
typedef unsigned int        UINT;
typedef UINT                UCHAR;
typedef UCHAR               *PUCHAR;
typedef unsigned long long  ULONGLONG;


#define BCRYPT_MD2_ALGORITHM                    L"MD2"
#define BCRYPT_MD4_ALGORITHM                    L"MD4"
#define BCRYPT_MD5_ALGORITHM                    L"MD5"
#define BCRYPT_SHA1_ALGORITHM                   L"SHA1"
#define BCRYPT_SHA256_ALGORITHM                 L"SHA256"
#define BCRYPT_SHA384_ALGORITHM                 L"SHA384"
#define BCRYPT_SHA512_ALGORITHM                 L"SHA512"

#define NULL    0

int intgen();

NTSTATUS BCryptOpenAlgorithmProvider(
	BCRYPT_ALG_HANDLE   *phAlgorithm,
	LPCWSTR             pszAlgId,
	LPCWSTR             pszImplementation,
	ULONG               dwFlags)
{
	return intgen();
}


NTSTATUS BCryptDeriveKeyPBKDF2(
    BCRYPT_ALG_HANDLE hPrf,
    PUCHAR            pbPassword,
    ULONG             cbPassword,
    PUCHAR            pbSalt,
    ULONG             cbSalt,
    ULONGLONG         cIterations,
    PUCHAR            pbDerivedKey,
    ULONG             cbDerivedKey,
    ULONG             dwFlags)
{
    return intgen();
}

NTSTATUS BCryptCloseAlgorithmProvider(
  BCRYPT_ALG_HANDLE hAlgorithm,
  ULONG             dwFlags
)
{
    return intgen();
}