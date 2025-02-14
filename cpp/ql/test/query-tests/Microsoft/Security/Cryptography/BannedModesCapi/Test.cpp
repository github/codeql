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

// dwParam
#define KP_IV                   1       // Initialization vector
#define KP_SALT                 2       // Salt value
#define KP_PADDING              3       // Padding values
#define KP_MODE                 4       // Mode of the cipher
#define KP_MODE_BITS            5       // Number of bits to feedback
#define KP_PERMISSIONS          6       // Key permissions DWORD
#define KP_ALGID                7       // Key algorithm
#define KP_BLOCKLEN             8       // Block size of the cipher
#define KP_KEYLEN               9       // Length of key in bits
#define KP_SALT_EX              10      // Length of salt in bytes
#define KP_P                    11      // DSS/Diffie-Hellman P value
#define KP_G                    12      // DSS/Diffie-Hellman G value
#define KP_Q                    13      // DSS Q value
#define KP_X                    14      // Diffie-Hellman X value
#define KP_Y                    15      // Y value
#define KP_RA                   16      // Fortezza RA value
#define KP_RB                   17      // Fortezza RB value
#define KP_INFO                 18      // for putting information into an RSA envelope
#define KP_EFFECTIVE_KEYLEN     19      // setting and getting RC2 effective key length
#define KP_SCHANNEL_ALG         20      // for setting the Secure Channel algorithms
#define KP_CLIENT_RANDOM        21      // for setting the Secure Channel client random data
#define KP_SERVER_RANDOM        22      // for setting the Secure Channel server random data
#define KP_RP                   23
#define KP_PRECOMP_MD5          24
#define KP_PRECOMP_SHA          25
#define KP_CERTIFICATE          26      // for setting Secure Channel certificate data (PCT1)
#define KP_CLEAR_KEY            27      // for setting Secure Channel clear key data (PCT1)
#define KP_PUB_EX_LEN           28
#define KP_PUB_EX_VAL           29
#define KP_KEYVAL               30
#define KP_ADMIN_PIN            31
#define KP_KEYEXCHANGE_PIN      32
#define KP_SIGNATURE_PIN        33
#define KP_PREHASH              34
#define KP_ROUNDS               35
#define KP_OAEP_PARAMS          36      // for setting OAEP params on RSA keys
#define KP_CMS_KEY_INFO         37
#define KP_CMS_DH_KEY_INFO      38
#define KP_PUB_PARAMS           39      // for setting public parameters
#define KP_VERIFY_PARAMS        40      // for verifying DSA and DH parameters
#define KP_HIGHEST_VERSION      41      // for TLS protocol version setting
#define KP_GET_USE_COUNT        42      // for use with PP_CRYPT_COUNT_KEY_USE contexts
#define KP_PIN_ID               43
#define KP_PIN_INFO             44

// KP_PADDING
#define PKCS5_PADDING           1       // PKCS 5 (sec 6.2) padding method
#define RANDOM_PADDING          2
#define ZERO_PADDING            3

// KP_MODE
#define CRYPT_MODE_CBC          1       // Cipher block chaining
#define CRYPT_MODE_ECB          2       // Electronic code book
#define CRYPT_MODE_OFB          3       // Output feedback mode
#define CRYPT_MODE_CFB          4       // Cipher feedback mode
#define CRYPT_MODE_CTS          5       // Ciphertext stealing mode

BOOL
CryptSetKeyParam(
	HCRYPTKEY   hKey,
	DWORD       dwParam,
	CONST BYTE  *pbData,
	DWORD       dwFlags
);

BOOL
SomeOtherFunction(
	HCRYPTKEY   hKey,
	DWORD       dwParam,
	CONST BYTE  *pbData,
	DWORD       dwFlags
);
void
DummyFunction(
	DWORD       dwParam,
	ALG_ID      dwData)
{
	CryptSetKeyParam(0, dwParam, (BYTE*)&dwData, 0);
}


// Macro testing
#define MACRO_INVOCATION_SETKPMODE(p) { DWORD dwData = p; \
		CryptSetKeyParam(0, KP_MODE, (BYTE*)&dwData, 0); }

int main()
{
	DWORD val = 0;
	////////////////////////////
	// Should fire an event
	val = CRYPT_MODE_ECB;
	CryptSetKeyParam(0, KP_MODE, (BYTE*)&val, 0);
	val = CRYPT_MODE_OFB;
	CryptSetKeyParam(0, KP_MODE, (BYTE*)&val, 0);
	val = CRYPT_MODE_CFB;
	CryptSetKeyParam(0, KP_MODE, (BYTE*)&val, 0);
	val = CRYPT_MODE_CTS;
	CryptSetKeyParam(0, KP_MODE, (BYTE*)&val, 0);
	val = 6;
	CryptSetKeyParam(0, KP_MODE, (BYTE*)&val, 0);
	DummyFunction(KP_MODE, CRYPT_MODE_ECB);
	MACRO_INVOCATION_SETKPMODE(CRYPT_MODE_CTS)

	////////////////////////////
	// Should not fire an event
	val = CRYPT_MODE_CBC;
	CryptSetKeyParam(0, KP_MODE, (BYTE*)&val, 0);
	val = CRYPT_MODE_ECB;
	CryptSetKeyParam(0, KP_PADDING, (BYTE*)&val, 0);
	SomeOtherFunction(0, KP_MODE, (BYTE*)&val, 0);
}