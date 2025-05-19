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

// algorithm identifier definitions
#define ALG_CLASS_DATA_ENCRYPT          (3 << 13)
#define ALG_TYPE_ANY                    (0)
#define ALG_TYPE_BLOCK                  (3 << 9)
#define ALG_TYPE_STREAM                 (4 << 9)
#define ALG_TYPE_THIRDPARTY             (8 << 9)
#define ALG_SID_THIRDPARTY_ANY          (0)

#define ALG_SID_DES                     1
#define ALG_SID_3DES                    3
#define ALG_SID_DESX                    4
#define ALG_SID_IDEA                    5
#define ALG_SID_CAST                    6
#define ALG_SID_SAFERSK64               7
#define ALG_SID_SAFERSK128              8
#define ALG_SID_3DES_112                9
#define ALG_SID_CYLINK_MEK              12
#define ALG_SID_RC5                     13
#define ALG_SID_AES_128                 14
#define ALG_SID_AES_192                 15
#define ALG_SID_AES_256                 16
#define ALG_SID_AES                     17
// Fortezza sub-ids
#define ALG_SID_SKIPJACK                10
#define ALG_SID_TEK                     11
// RC2 sub-ids
#define ALG_SID_RC2                     2
// Stream cipher sub-ids
#define ALG_SID_RC4                     1
#define ALG_SID_SEAL                    2

// CAPI encryption algorithm definitions
#define CALG_DES                (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_DES)
#define CALG_3DES_112           (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_3DES_112)
#define CALG_3DES               (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_3DES)
#define CALG_DESX               (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_DESX)
#define CALG_RC2                (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_RC2)
#define CALG_RC4                (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_STREAM|ALG_SID_RC4)
#define CALG_SEAL               (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_STREAM|ALG_SID_SEAL)
#define CALG_SKIPJACK           (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_SKIPJACK)
#define CALG_TEK                (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_TEK)
#define CALG_CYLINK_MEK         (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_CYLINK_MEK)  // Deprecated. Do not use
#define CALG_RC5                (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_RC5)
#define CALG_AES_128            (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_AES_128)
#define CALG_AES_192            (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_AES_192)
#define CALG_AES_256            (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_AES_256)
#define CALG_AES                (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_AES)
#define CALG_THIRDPARTY_CIPHER  (ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_THIRDPARTY | ALG_SID_THIRDPARTY_ANY)


#define BCRYPT_RC2_ALGORITHM                    L"RC2"
#define BCRYPT_RC4_ALGORITHM                    L"RC4"
#define BCRYPT_AES_ALGORITHM                    L"AES"
#define BCRYPT_DES_ALGORITHM                    L"DES"
#define BCRYPT_DESX_ALGORITHM                   L"DESX"
#define BCRYPT_3DES_ALGORITHM                   L"3DES"
#define BCRYPT_3DES_112_ALGORITHM               L"3DES_112"
#define BCRYPT_AES_GMAC_ALGORITHM               L"AES-GMAC"
#define BCRYPT_AES_CMAC_ALGORITHM               L"AES-CMAC"
#define BCRYPT_XTS_AES_ALGORITHM                L"XTS-AES"

BOOL
CryptGenKey(
	HCRYPTPROV  hProv,
	ALG_ID      Algid,
	DWORD       dwFlags,
	HCRYPTKEY   *phKey) 
{
	return 0;
}

BOOL
CryptDeriveKey(
	HCRYPTPROV  hProv,
	ALG_ID      Algid,
	HCRYPTHASH  hBaseData,
	DWORD       dwFlags,
	HCRYPTKEY   *phKey) 
{
	return 0;
}

void
DummyFunction(
	LPCWSTR pszAlgId,
	ALG_ID      Algid) 
{}

NTSTATUS
BCryptOpenAlgorithmProvider(
	BCRYPT_ALG_HANDLE   *phAlgorithm,
	LPCWSTR pszAlgId,
	LPCWSTR pszImplementation,
	ULONG   dwFlags) 
{
	return 0;
}

// Macro testing
#define MACRO_INVOCATION_CRYPTGENKEY CryptGenKey(0, CALG_RC4, 0, 0);
#define MACRO_INVOCATION_CRYPTDERIVEKEY CryptDeriveKey(0, CALG_CYLINK_MEK, 0, 0, 0);
#define MACRO_INVOCATION_CNG BCryptOpenAlgorithmProvider(0, BCRYPT_3DES_112_ALGORITHM, 0, 0);

int main()
{
	////////////////////////////
	// CAPI Test section
	// Should fire an event
	CryptGenKey(0, CALG_DES, 0, 0);
	CryptGenKey(0, CALG_3DES_112, 0, 0);
	CryptGenKey(0, CALG_3DES, 0, 0);
	CryptGenKey(0, CALG_DESX, 0, 0);
	CryptGenKey(0, CALG_RC2, 0, 0);
	CryptGenKey(0, CALG_RC4, 0, 0);
	CryptGenKey(0, CALG_SEAL, 0, 0);
	CryptGenKey(0, CALG_SKIPJACK, 0, 0);
	CryptGenKey(0, CALG_TEK, 0, 0);
	CryptGenKey(0, CALG_CYLINK_MEK, 0, 0);
	CryptGenKey(0, CALG_RC5, 0, 0);
	CryptGenKey(0, CALG_THIRDPARTY_CIPHER, 0, 0);
	CryptGenKey(0, ALG_CLASS_DATA_ENCRYPT, 0, 0);
	CryptGenKey(0, ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK, 0, 0);
	CryptGenKey(0, ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_STREAM, 0, 0);
	// Verifying that all stream ciphers are flagged
	CryptGenKey(0, ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_STREAM | ALG_SID_AES, 0, 0);
	// Verifying that invocations through a macro are flagged
	MACRO_INVOCATION_CRYPTGENKEY
	// Numeric representation
	CryptGenKey(0, 0x6609, 0, 0);

	CryptDeriveKey(0, CALG_DES, 0, 0, 0);
	CryptDeriveKey(0, CALG_3DES_112, 0, 0, 0);
	CryptDeriveKey(0, CALG_3DES, 0, 0, 0);
	CryptDeriveKey(0, CALG_DESX, 0, 0, 0);
	CryptDeriveKey(0, CALG_RC2, 0, 0, 0);
	CryptDeriveKey(0, CALG_RC4, 0, 0, 0);
	CryptDeriveKey(0, CALG_SEAL, 0, 0, 0);
	CryptDeriveKey(0, CALG_SKIPJACK, 0, 0, 0);
	CryptDeriveKey(0, CALG_TEK, 0, 0, 0);
	CryptDeriveKey(0, CALG_CYLINK_MEK, 0, 0, 0);
	CryptDeriveKey(0, CALG_RC5, 0, 0, 0);
	CryptDeriveKey(0, CALG_THIRDPARTY_CIPHER, 0, 0, 0);
	CryptDeriveKey(0, ALG_CLASS_DATA_ENCRYPT, 0, 0, 0);
	CryptDeriveKey(0, ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_BLOCK, 0, 0, 0);
	CryptDeriveKey(0, ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_STREAM, 0, 0, 0);
	// Verifying that all stream ciphers are flagged
	CryptDeriveKey(0, ALG_CLASS_DATA_ENCRYPT | ALG_TYPE_STREAM | ALG_SID_AES, 0, 0, 0);
	// Verifying that invocations through a macro are flagged
	MACRO_INVOCATION_CRYPTDERIVEKEY
	// Numeric representation
	CryptDeriveKey(0, 0x6609, 0, 0, 0);

	// Should not fire an event
	CryptGenKey(0, CALG_AES_128, 0, 0);
	CryptGenKey(0, CALG_AES_192, 0, 0);
	CryptGenKey(0, CALG_AES_256, 0, 0);
	CryptGenKey(0, CALG_AES, 0, 0);
	CryptDeriveKey(0, CALG_AES_128, 0, 0, 0);
	CryptDeriveKey(0, CALG_AES_192, 0, 0, 0);
	CryptDeriveKey(0, CALG_AES_256, 0, 0, 0);
	CryptDeriveKey(0, CALG_AES, 0, 0, 0);
	if (CALG_RC5 > 0)
	{
		DummyFunction(0, CALG_SKIPJACK);
	}

	/////////////////////////////
	// CNG Test section
	// Should fire an event
	BCryptOpenAlgorithmProvider(0, BCRYPT_RC2_ALGORITHM, 0, 0);
	BCryptOpenAlgorithmProvider(0, BCRYPT_RC4_ALGORITHM, 0, 0);
	BCryptOpenAlgorithmProvider(0, BCRYPT_DES_ALGORITHM, 0, 0);
	BCryptOpenAlgorithmProvider(0, BCRYPT_DESX_ALGORITHM, 0, 0);
	BCryptOpenAlgorithmProvider(0, BCRYPT_3DES_ALGORITHM, 0, 0);
	BCryptOpenAlgorithmProvider(0, BCRYPT_3DES_112_ALGORITHM, 0, 0);
	BCryptOpenAlgorithmProvider(0, BCRYPT_AES_GMAC_ALGORITHM, 0, 0);
	BCryptOpenAlgorithmProvider(0, BCRYPT_AES_CMAC_ALGORITHM, 0, 0);
	BCryptOpenAlgorithmProvider(0, L"3DES", 0, 0);
	MACRO_INVOCATION_CNG

	// Should not fire an event
	BCryptOpenAlgorithmProvider(0, BCRYPT_AES_ALGORITHM, 0, 0);
	BCryptOpenAlgorithmProvider(0, BCRYPT_XTS_AES_ALGORITHM, 0, 0);
}