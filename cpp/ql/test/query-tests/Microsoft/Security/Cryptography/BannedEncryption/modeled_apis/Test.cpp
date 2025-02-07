#include "./openssl/other.h"

// Other RC4
void RC4()
{
	int myRc4 = 0;
}

void* malloc(int size);

#define MACRO_RC4 RC4(0, 0, 0, 0);
#define NULL 0

void func_calls()
{
	// Should not be flagged
	AES_encrypt(0, 0, 0);
	AES_cbc_encrypt(0, 0, 0, 0, 0, 0);

	// OK Encryption but bad mode
	AES_ecb_encrypt(0, 0, 0, 0);
	AES_cfb128_encrypt(0, 0, 0, 0, 0, 0, 0);
	AES_cfb1_encrypt(0, 0, 0, 0, 0, 0, 0);
	AES_cfb8_encrypt(0, 0, 0, 0, 0, 0, 0);
	AES_ofb128_encrypt(0, 0, 0, 0, 0, 0);
	AES_ige_encrypt(0, 0, 0, 0, 0, 0);
	AES_bi_ige_encrypt(0, 0, 0, 0, 0, 0, 0);

	// Everything else should be flagged as bad encryption
	MACRO_RC4
	BF_encrypt(0,0);
	BF_ecb_encrypt(0,0,0,0);
	BF_cbc_encrypt(0, 0, 0, 0, 0, 0);
	BF_cfb64_encrypt(0, 0, 0, 0, 0, 0,0);
	BF_ofb64_encrypt(0, 0, 0, 0, 0, 0);
	Camellia_encrypt(0,0,0);
	Camellia_ecb_encrypt(0, 0, 0, 0);
	Camellia_cbc_encrypt(0, 0, 0, 0, 0, 0);
	Camellia_cfb128_encrypt(0, 0, 0, 0, 0, 0, 0);
	Camellia_cfb1_encrypt(0, 0, 0, 0, 0, 0, 0);
	Camellia_cfb8_encrypt(0, 0, 0, 0, 0, 0,0);
	Camellia_ofb128_encrypt(0, 0, 0, 0, 0, 0);
	Camellia_ctr128_encrypt(0, 0, 0, 0, 0, 0,0);
	DES_ecb3_encrypt(0,0,0,0,0,0);
	DES_cbc_encrypt(0, 0, 0, 0, 0, 0);
	DES_ncbc_encrypt(0, 0, 0, 0, 0, 0);
	DES_xcbc_encrypt(0, 0, 0, 0, 0, 0,0,0);
	DES_cfb_encrypt(0, 0, 0, 0, 0, 0,0);
	DES_ecb_encrypt(0, 0, 0, 0);
	DES_encrypt1(0, 0, 0);
	DES_encrypt2(0, 0, 0);
	DES_encrypt3(0, 0, 0,0);
	DES_ede3_cbc_encrypt(0, 0, 0, 0, 0, 0, 0,0);
	DES_ofb64_encrypt(0,0,0,0,0,0);
	IDEA_ecb_encrypt(0,0,0);
	IDEA_cbc_encrypt(0,0,0,0,0,0);
	IDEA_cfb64_encrypt(0, 0, 0, 0, 0, 0,0);
	IDEA_ofb64_encrypt(0, 0, 0, 0, 0, 0);
	IDEA_encrypt(0, 0);
	RC2_ecb_encrypt(0, 0, 0, 0);
	RC2_encrypt(0, 0);
	RC2_cbc_encrypt(0, 0, 0, 0, 0, 0);
	RC2_cfb64_encrypt(0, 0, 0, 0, 0, 0,0);
	RC2_ofb64_encrypt(0, 0, 0, 0, 0, 0);
	RC5_32_ecb_encrypt(0, 0, 0, 0);
	RC5_32_encrypt(0,0);
	RC5_32_cbc_encrypt(0, 0, 0, 0, 0, 0);
	RC5_32_cfb64_encrypt(0, 0, 0, 0, 0, 0, 0);
	RC5_32_ofb64_encrypt(0, 0, 0, 0, 0, 0);
	RC4_set_key(0,0,0);
	RC4(0, 0, 0, 0);
}

void non_func_calls(int argc, char **argv)
{
	// GOOD cases: should not be flagged
	{
		EVP_CIPHER *cipher = NULL;
		ASN1_OBJECT *obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));

		cipher = EVP_CIPHER_fetch(NULL, "aes-256-xts", NULL);
		cipher = EVP_get_cipherbyname("aes-128-cbc");
		cipher = EVP_get_cipherbynid(423); //NID 423 is aes-192-cbc
		obj->nid = 913; // NID 913 is aes-128-xts
		cipher = EVP_get_cipherbyobj(obj);
		obj = (ASN1_OBJECT*)malloc(sizeof(ASN1_OBJECT));
		obj->sn = "aes-128-cbc-hmac-sha1";
		cipher = EVP_get_cipherbyobj(obj);

		// Indirect flow through transformative functions (i.e., converting the alg format)
		int nid = OBJ_obj2nid(obj);
		cipher = EVP_get_cipherbynid(nid);
		ASN1_OBJECT *obj_cpy = OBJ_dup(obj);
		cipher = EVP_get_cipherbyobj(obj_cpy);
		char* name = "THIS STRING WILL BE OVERWRITTEN";
		OBJ_obj2txt(name, 0, obj, 0);
		cipher = EVP_get_cipherbyname(name);
		nid = OBJ_obj2nid(obj_cpy);
		name = OBJ_nid2sn(nid);
		ASN1_OBJECT *obj2 = OBJ_txt2obj(name, 0);
		cipher = EVP_get_cipherbyobj(obj2);
	}

	// Bad Cases: UNKNOWN algorithms
	{
		EVP_CIPHER *cipher = NULL;
		ASN1_OBJECT *obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));

		cipher = EVP_CIPHER_fetch(NULL, "FOOBAR", NULL);
		cipher = EVP_get_cipherbyname("TEST");
		cipher = EVP_get_cipherbynid(2000);
		obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));
		obj->nid = 1999;
		cipher = EVP_get_cipherbyobj(obj);
		obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));
		obj->sn = "Test2";
		cipher = EVP_get_cipherbyobj(obj);
		obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));
		obj->sn = argv[0]; // Ignoring the possible overflow
		cipher = EVP_get_cipherbyobj(obj);

		cipher = EVP_CIPHER_fetch(NULL, "NULL", NULL); 
		cipher = EVP_CIPHER_fetch(NULL, "othermailbox", NULL); 

		cipher = EVP_get_cipherbynid(0); 

		// Indirect flow through transformative functions (i.e., converting the alg format)
		// Testing flow with unknown inputs should be sufficient with known bad inputs, 
		// so only testing with known bad inputs for UNKNOWN for now. 
		ASN1_OBJECT *obj_cpy = NULL;
		ASN1_OBJECT *obj2 = NULL;
		obj->nid = 1998;
		int nid = OBJ_obj2nid(obj);
		cipher = EVP_get_cipherbynid(nid);
		obj->nid = 1997;
		obj_cpy = OBJ_dup(obj);
		cipher = EVP_get_cipherbyobj(obj_cpy);
		obj->sn = "NOT AN ALG";
		char* name = "THIS STRING WILL BE OVERWRITTEN";
		OBJ_obj2txt(name, 0, obj, 0);
		cipher = EVP_get_cipherbyname(name);
		obj->nid = 1996;
		obj_cpy = OBJ_dup(obj);
		nid = OBJ_obj2nid(obj_cpy);
		name = OBJ_nid2sn(nid);
		obj2 = OBJ_txt2obj(name, 0);
		cipher = EVP_get_cipherbyobj(obj2);

		// Nonsense cases (known algorithms to incorrect sinks)
		cipher = EVP_get_cipherbynid(19); // NID 19 is RSA 
		cipher = EVP_get_cipherbyname("secp160k1"); // An elliptic curve
	}

	// Bad Cases: Banned algorithms
	{
		EVP_CIPHER *cipher = NULL;
		ASN1_OBJECT *obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));

		// banned symmetric ciphers
		cipher = EVP_CIPHER_fetch(NULL, "des-ede3", NULL);
		cipher = EVP_get_cipherbyname("des-ede3-cbc");
		cipher = EVP_get_cipherbynid(31); // NID 31 is des-cbc
		obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));
		obj->nid = 30; // NID 30 is des-cfb
		cipher = EVP_get_cipherbyobj(obj);
		obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));
		obj->sn = "camellia256";
		cipher = EVP_get_cipherbyobj(obj);
		cipher = EVP_CIPHER_fetch(NULL, "rc4", NULL);
		cipher = EVP_get_cipherbyname("rc4-40");
		cipher = EVP_get_cipherbynid(5); // NID 5 is rc4
		obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));
		obj->sn = "desx-cbc";
		cipher = EVP_get_cipherbyobj(obj);
		cipher = EVP_CIPHER_fetch(NULL, "bf-cbc", NULL);
		cipher = EVP_get_cipherbyname("rc2-64-cbc");
		cipher = EVP_get_cipherbynid(1019); // NID 1019 is chacha20
		obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));
		obj->nid = 813; // NID 813 is gost89
		cipher = EVP_get_cipherbyobj(obj);
		obj = (ASN1_OBJECT *)malloc(sizeof(ASN1_OBJECT));
		obj->sn = "sm4-cbc";
		cipher = EVP_get_cipherbyobj(obj);
	}
}

int main(int argc, char **argv)
{
	func_calls();
	non_func_calls(argc, argv);	
}