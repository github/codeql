
typedef unsigned long size_t;

// --- simple encryption macro invocations ---

void my_implementation1(void *data, size_t amount);
void my_implementation2(void *data, size_t amount);
void my_implementation3(void *data, size_t amount);
void my_implementation4(void *data, size_t amount);
void my_implementation5(void *data, size_t amount);
void my_implementation6(const char *str);

#define ENCRYPT_WITH_DES(data, amount) my_implementation1(data, amount)
#define ENCRYPT_WITH_RC2(data, amount) my_implementation2(data, amount)
#define ENCRYPT_WITH_AES(data, amount) my_implementation3(data, amount)
#define ENCRYPT_WITH_3DES(data, amount) my_implementation4(data, amount)
#define ENCRYPT_WITH_TRIPLE_DES(data, amount) my_implementation4(data, amount)
#define ENCRYPT_WITH_RC20(data, amount) my_implementation5(data, amount)
#define ENCRYPT_WITH_DES_REMOVED(data, amount)

#define DESENCRYPT(data, amount) my_implementation1(data, amount)
#define RC2ENCRYPT(data, amount) my_implementation2(data, amount)
#define AESENCRYPT(data, amount) my_implementation3(data, amount)
#define DES3ENCRYPT(data, amount) my_implementation4(data, amount)

#define DES_DO_ENCRYPTION(data, amount) my_implementation1(data, amount)
#define RUN_DES_ENCODING(data, amount) my_implementation1(data, amount)
#define DES_ENCODE(data, amount) my_implementation1(data, amount)
#define DES_SET_KEY(data, amount) my_implementation1(data, amount)

#define DES(str) my_implementation6(str)
#define DESMOND(str) my_implementation6(str)
#define ANODES(str) my_implementation6(str)
#define SORT_ORDER_DES (1)

void test_macros(void *data, size_t amount, const char *str)
{
	ENCRYPT_WITH_DES(data, amount); // BAD
	ENCRYPT_WITH_RC2(data, amount); // BAD
	ENCRYPT_WITH_AES(data, amount); // GOOD (good algorithm)
	ENCRYPT_WITH_3DES(data, amount); // BAD
	ENCRYPT_WITH_TRIPLE_DES(data, amount); // BAD
	ENCRYPT_WITH_RC20(data, amount); // GOOD (if there ever is an RC20 algorithm, we have no reason to believe it's weak)
	ENCRYPT_WITH_DES_REMOVED(data, amount); // GOOD (implementation has been deleted)

	DESENCRYPT(data, amount); // BAD [NOT DETECTED]
	RC2ENCRYPT(data, amount); // BAD [NOT DETECTED]
	AESENCRYPT(data, amount); // GOOD (good algorithm)
	DES3ENCRYPT(data, amount); // BAD [NOT DETECTED]

	DES_DO_ENCRYPTION(data, amount); // BAD
	RUN_DES_ENCODING(data, amount); // BAD
	DES_ENCODE(data, amount); // BAD
	DES_SET_KEY(data, amount); // BAD

	DES(str); // GOOD (probably nothing to do with encryption)
	DESMOND(str); // GOOD (probably nothing to do with encryption)
	ANODES(str); // GOOD (probably nothing to do with encryption)
	int ord = SORT_ORDER_DES; // GOOD (probably nothing to do with encryption)
}

// --- simple encryption function calls ---

void encryptDES(void *data, size_t amount);
void encryptRC2(void *data, size_t amount);
void encryptAES(void *data, size_t amount);
void encrypt3DES(void *data, size_t amount);
void encryptTripleDES(void *data, size_t amount);

void DESEncrypt(void *data, size_t amount);
void RC2Encrypt(void *data, size_t amount);
void AESEncrypt(void *data, size_t amount);
void DES3Encrypt(void *data, size_t amount);

void DoDESEncryption(void *data, size_t amount);
void encryptDes(void *data, size_t amount);
void do_des_encrypt(void *data, size_t amount);
void DES_Set_Key(const char *key);
void DESSetKey(const char *key);

int Des();
void Desmond(const char *str);
void Anodes(int i);
void ConDes();

void test_functions(void *data, size_t amount, const char *str)
{
	encryptDES(data, amount); // BAD
	encryptRC2(data, amount); // BAD
	encryptAES(data, amount); // GOOD (good algorithm)
	encrypt3DES(data, amount); // BAD
	encryptTripleDES(data, amount); // BAD

	DESEncrypt(data, amount); // BAD [NOT DETECTED]
	RC2Encrypt(data, amount); // BAD [NOT DETECTED]
	AESEncrypt(data, amount); // GOOD (good algorithm)
	DES3Encrypt(data, amount); // BAD [NOT DETECTED]

	DoDESEncryption(data, amount); // BAD [NOT DETECTED]
	encryptDes(data, amount); // BAD [NOT DETECTED]
	do_des_encrypt(data, amount); // BAD
	DES_Set_Key(str); // BAD [NOT DETECTED]
	DESSetKey(str); // BAD [NOT DETECTED]

	Des(); // GOOD (probably nothing to do with encryption)
	Desmond(str); // GOOD (probably nothing to do with encryption)
	Anodes(1); // GOOD (probably nothing to do with encryption)
	ConDes(); // GOOD (probably nothing to do with encryption)
}

// --- macros for functions with no arguments ---

void my_implementation7();
void my_implementation8();

#define INIT_ENCRYPT_WITH_DES() my_implementation7()
#define INIT_ENCRYPT_WITH_AES() my_implementation8()

void test_macros2()
{
	INIT_ENCRYPT_WITH_DES(); // BAD [NOT DETECTED]
	INIT_ENCRYPT_WITH_AES(); // GOOD (good algorithm)
	
	// ...
}