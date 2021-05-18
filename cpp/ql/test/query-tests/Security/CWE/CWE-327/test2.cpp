
typedef unsigned long size_t;

int strcmp(const char *s1, const char *s2);
void abort(void);

struct keytype
{
    char data[16];
};

void my_des_implementation(char *data, size_t amount, keytype key);
void my_rc2_implementation(char *data, size_t amount, keytype key);
void my_aes_implementation(char *data, size_t amount, keytype key);
void my_3des_implementation(char *data, size_t amount, keytype key);

typedef void (*implementation_fn_ptr)(char *data, size_t amount, keytype key);

// --- more involved C-style example ---

#define ALGO_DES (1)
#define ALGO_AES (2)

int all_algos[] = {
	ALGO_DES,
	ALGO_AES
};

void encrypt_good(char *data, size_t amount, keytype key, int algo)
{
	switch (algo)
	{
	case ALGO_DES:
		abort();

	case ALGO_AES:
		{
			my_aes_implementation(data, amount, key); // GOOD
		} break;
	}
};

void encrypt_bad(char *data, size_t amount, keytype key, int algo)
{
	switch (algo)
	{
	case ALGO_DES:
		{
			my_des_implementation(data, amount, key); // BAD
		} break;

	case ALGO_AES:
		{
			my_aes_implementation(data, amount, key); // GOOD
		} break;
	}
};

void do_encrypts(char *data, size_t amount, keytype key)
{
	encrypt_good(data, amount, key, ALGO_AES); // GOOD
	encrypt_bad(data, amount, key, ALGO_DES); // BAD
}

// --- more involved CPP-style example ---

enum algorithm
{
	DES,
	AES
};

algorithm all_algorithms[] = {
	DES,
	AES
};

class MyGoodEncryptor
{
public:
	MyGoodEncryptor(keytype _key, algorithm _algo) : key(_key), algo(_algo) {};

	void encrypt(char *data, size_t amount);

private:
	keytype key;
	algorithm algo;
};

void MyGoodEncryptor :: encrypt(char *data, size_t amount)
{
	switch (algo)
	{
	case DES:
		{
			throw "DES is not a good choice of encryption algorithm!";
		} break;

	case AES:
		{
			my_aes_implementation(data, amount, key); // GOOD
		} break;
	}
}

class MyBadEncryptor
{
public:
	MyBadEncryptor(keytype _key, algorithm _algo) : key(_key), algo(_algo) {};

	void encrypt(char *data, size_t amount);

private:
	keytype key;
	algorithm algo;
};

void MyBadEncryptor :: encrypt(char *data, size_t amount)
{
	switch (algo)
	{
	case DES:
		{
			my_des_implementation(data, amount, key); // BAD
		} break;

	case AES:
		{
			my_aes_implementation(data, amount, key); // GOOD
		} break;
	}
}

void do_class_encrypts(char *data, size_t amount, keytype key)
{
	{
		MyGoodEncryptor mge(key, AES); // GOOD

		mge.encrypt(data, amount);

	}

	{
		MyBadEncryptor mbe(key, DES); // BAD

		mbe.encrypt(data, amount);
	}
}

// --- unseen implementation ---

enum use_algorithm
{
	USE_DES,
	USE_AES
};

void set_encryption_algorithm1(int algorithm);
void set_encryption_algorithm2(use_algorithm algorithm);
void set_encryption_algorithm3(const char *algorithm_str);

void encryption_with1(char *data, size_t amount, keytype key, int algorithm);
void encryption_with2(char *data, size_t amount, keytype key, use_algorithm algorithm);
void encryption_with3(char *data, size_t amount, keytype key, const char *algorithm_str);

int get_algorithm1();
use_algorithm get_algorithm2();
const char *get_algorithm3();

void do_unseen_encrypts(char *data, size_t amount, keytype key)
{
	set_encryption_algorithm1(ALGO_DES); // BAD
	set_encryption_algorithm1(ALGO_AES); // GOOD

	set_encryption_algorithm2(USE_DES); // BAD
	set_encryption_algorithm2(USE_AES); // GOOD

	set_encryption_algorithm3("DES"); // BAD [NOT DETECTED]
	set_encryption_algorithm3("AES"); // GOOD
	set_encryption_algorithm3("AES-256"); // GOOD

	encryption_with1(data, amount, key, ALGO_DES); // BAD
	encryption_with1(data, amount, key, ALGO_AES); // GOOD

	encryption_with2(data, amount, key, USE_DES); // BAD
	encryption_with2(data, amount, key, USE_AES); // GOOD

	encryption_with3(data, amount, key, "DES"); // BAD [NOT DETECTED]
	encryption_with3(data, amount, key, "AES"); // GOOD
	encryption_with3(data, amount, key, "AES-256"); // GOOD

	if (get_algorithm1() == ALGO_DES) // GOOD
	{
		throw "DES is not a good choice of encryption algorithm!";
	}
	if (get_algorithm2() == USE_DES) // GOOD
	{
		throw "DES is not a good choice of encryption algorithm!";
	}
	if (strcmp(get_algorithm3(), "DES") == 0) // GOOD
	{
		throw "DES is not a good choice of encryption algorithm!";
	}
}

// --- classes ---

class desEncrypt
{
public:
	static void encrypt(const char *data);
	static void doSomethingElse();
};

class aes256Encrypt
{
public:
	static void encrypt(const char *data);
	static void doSomethingElse();
};

class desCipher
{
public:
	void encrypt(const char *data);
	void doSomethingElse();
};

class aesCipher
{
public:
	void encrypt(const char *data);
	void doSomethingElse();
};

void do_classes(const char *data)
{
	desEncrypt::encrypt(data); // BAD
	aes256Encrypt::encrypt(data); // GOOD
	desEncrypt::doSomethingElse(); // GOOD
	aes256Encrypt::doSomethingElse(); // GOOD

	desCipher dc;
	aesCipher ac;
	dc.encrypt(data); // BAD
	ac.encrypt(data); // GOOD
	dc.doSomethingElse(); // GOOD
	ac.doSomethingElse(); // GOOD
}

// --- function pointer ---

void do_fn_ptr(char *data, size_t amount, keytype key)
{
	implementation_fn_ptr impl;

	impl = &my_des_implementation; // BAD [NOT DETECTED]
	impl(data, amount, key);

	impl = &my_aes_implementation; // GOOD
	impl(data, amount, key);
}
