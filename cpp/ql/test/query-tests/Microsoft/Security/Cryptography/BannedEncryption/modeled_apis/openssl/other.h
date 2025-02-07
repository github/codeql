struct asn1_object_st {
    const char *sn, *ln;
    int nid;
    int length;
    const unsigned char *data;  /* data remains const after init */
    int flags;                  /* Should we free this one */
};
typedef struct asn1_object_st ASN1_OBJECT;

struct evp_cipher_st {
    int nid;

    int block_size;
    /* Default value for variable length ciphers */
    int key_len;
    int iv_len;

    // /* Legacy structure members */
    // /* Various flags */
    // unsigned long flags;
    // /* How the EVP_CIPHER was created. */
    // int origin;
    // /* init key */
    // int (*init) (EVP_CIPHER_CTX *ctx, const unsigned char *key,
    //              const unsigned char *iv, int enc);
    // /* encrypt/decrypt data */
    // int (*do_cipher) (EVP_CIPHER_CTX *ctx, unsigned char *out,
    //                   const unsigned char *in, size_t inl);
    // /* cleanup ctx */
    // int (*cleanup) (EVP_CIPHER_CTX *);
    // /* how big ctx->cipher_data needs to be */
    // int ctx_size;
    // /* Populate a ASN1_TYPE with parameters */
    // int (*set_asn1_parameters) (EVP_CIPHER_CTX *, ASN1_TYPE *);
    // /* Get parameters from a ASN1_TYPE */
    // int (*get_asn1_parameters) (EVP_CIPHER_CTX *, ASN1_TYPE *);
    // /* Miscellaneous operations */
    // int (*ctrl) (EVP_CIPHER_CTX *, int type, int arg, void *ptr);
    // /* Application data */
    // void *app_data;

    // /* New structure members */
    // /* Above comment to be removed when legacy has gone */
    // int name_id;
    char *type_name;
    const char *description;
    // OSSL_PROVIDER *prov;
    // CRYPTO_REF_COUNT refcnt;
    // CRYPTO_RWLOCK *lock;
    // OSSL_FUNC_cipher_newctx_fn *newctx;
    // OSSL_FUNC_cipher_encrypt_init_fn *einit;
    // OSSL_FUNC_cipher_decrypt_init_fn *dinit;
    // OSSL_FUNC_cipher_update_fn *cupdate;
    // OSSL_FUNC_cipher_final_fn *cfinal;
    // OSSL_FUNC_cipher_cipher_fn *ccipher;
    // OSSL_FUNC_cipher_freectx_fn *freectx;
    // OSSL_FUNC_cipher_dupctx_fn *dupctx;
    // OSSL_FUNC_cipher_get_params_fn *get_params;
    // OSSL_FUNC_cipher_get_ctx_params_fn *get_ctx_params;
    // OSSL_FUNC_cipher_set_ctx_params_fn *set_ctx_params;
    // OSSL_FUNC_cipher_gettable_params_fn *gettable_params;
    // OSSL_FUNC_cipher_gettable_ctx_params_fn *gettable_ctx_params;
    // OSSL_FUNC_cipher_settable_ctx_params_fn *settable_ctx_params;
} /* EVP_CIPHER */ ;

typedef struct evp_cipher_st EVP_CIPHER;

typedef struct rc4_key_st {
	int x, y;
	int data[256];
} RC4_KEY;

struct key_st {
	unsigned long rd_key[4];
	int rounds;
};
typedef struct key_st AES_KEY, BF_KEY, CAMELLIA_KEY, DES_key_schedule, IDEA_KEY_SCHEDULE, RC2_KEY, RC5_32_KEY;

typedef unsigned int DES_LONG, BF_LONG;
typedef unsigned char DES_cblock[8];
typedef unsigned char const_DES_cblock[8];
typedef unsigned int size_t;


#define CAMELLIA_BLOCK_SIZE 4


// Symmetric Cipher Algorithm sinks
EVP_CIPHER *EVP_CIPHER_fetch(void *ctx, const char *algorithm, const char *properties);
EVP_CIPHER *EVP_get_cipherbyname(const char *name);
EVP_CIPHER *EVP_get_cipherbynid(int nid);
EVP_CIPHER *EVP_get_cipherbyobj(const ASN1_OBJECT *a);

// ----------https://www.openssl.org/docs/man1.1.1/man3/OBJ_obj2txt.html
ASN1_OBJECT *OBJ_nid2obj(int n);
char *OBJ_nid2ln(int n);
char *OBJ_nid2sn(int n);

int OBJ_obj2nid(const ASN1_OBJECT *o);
int OBJ_ln2nid(const char *ln);
int OBJ_sn2nid(const char *sn);

int OBJ_txt2nid(const char *s);

ASN1_OBJECT *OBJ_txt2obj(const char *s, int no_name);
int OBJ_obj2txt(char *buf, int buf_len, const ASN1_OBJECT *a, int no_name);

int i2t_ASN1_OBJECT(char *buf, int buf_len, const ASN1_OBJECT *a);

int OBJ_cmp(const ASN1_OBJECT *a, const ASN1_OBJECT *b);
ASN1_OBJECT *OBJ_dup(const ASN1_OBJECT *o);

int OBJ_create(const char *oid, const char *sn, const char *ln);
//-------------
//https://www.openssl.org/docs/man3.0/man3/EVP_CIPHER_get0_name.html
char *EVP_CIPHER_get0_name(const EVP_CIPHER *cipher);
//-----

void AES_encrypt(const unsigned char *in, unsigned char *out,
	const AES_KEY *key);
void AES_ecb_encrypt(const unsigned char *in, unsigned char *out,
	const AES_KEY *key, const int enc);
void AES_cbc_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const AES_KEY *key,
	unsigned char *ivec, const int enc);
void AES_cfb128_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const AES_KEY *key,
	unsigned char *ivec, int *num, const int enc);
void AES_cfb1_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const AES_KEY *key,
	unsigned char *ivec, int *num, const int enc);
void AES_cfb8_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const AES_KEY *key,
	unsigned char *ivec, int *num, const int enc);
void AES_ofb128_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const AES_KEY *key,
	unsigned char *ivec, int *num);
/* NB: the IV is _two_ blocks long */
void AES_ige_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const AES_KEY *key,
	unsigned char *ivec, const int enc);
/* NB: the IV is _four_ blocks long */
void AES_bi_ige_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const AES_KEY *key,
	const AES_KEY *key2, const unsigned char *ivec,
	const int enc);
void BF_encrypt(BF_LONG *data, const BF_KEY *key);
void BF_decrypt(BF_LONG *data, const BF_KEY *key);

void BF_ecb_encrypt(const unsigned char *in, unsigned char *out,
	const BF_KEY *key, int enc);
void BF_cbc_encrypt(const unsigned char *in, unsigned char *out, long length,
	const BF_KEY *schedule, unsigned char *ivec, int enc);
void BF_cfb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, const BF_KEY *schedule,
	unsigned char *ivec, int *num, int enc);
void BF_ofb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, const BF_KEY *schedule,
	unsigned char *ivec, int *num);
void Camellia_encrypt(const unsigned char *in, unsigned char *out,
	const CAMELLIA_KEY *key);
void Camellia_ecb_encrypt(const unsigned char *in, unsigned char *out,
	const CAMELLIA_KEY *key, const int enc);
void Camellia_cbc_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const CAMELLIA_KEY *key,
	unsigned char *ivec, const int enc);
void Camellia_cfb128_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const CAMELLIA_KEY *key,
	unsigned char *ivec, int *num, const int enc);
void Camellia_cfb1_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const CAMELLIA_KEY *key,
	unsigned char *ivec, int *num, const int enc);
void Camellia_cfb8_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const CAMELLIA_KEY *key,
	unsigned char *ivec, int *num, const int enc);
void Camellia_ofb128_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const CAMELLIA_KEY *key,
	unsigned char *ivec, int *num);
void Camellia_ctr128_encrypt(const unsigned char *in, unsigned char *out,
	size_t length, const CAMELLIA_KEY *key,
	unsigned char ivec[CAMELLIA_BLOCK_SIZE],
	unsigned char ecount_buf[CAMELLIA_BLOCK_SIZE],
	unsigned int *num);
void DES_ecb3_encrypt(const_DES_cblock *input, DES_cblock *output,
	DES_key_schedule *ks1, DES_key_schedule *ks2,
	DES_key_schedule *ks3, int enc);
void DES_cbc_encrypt(const unsigned char *input, unsigned char *output,
	long length, DES_key_schedule *schedule,
	DES_cblock *ivec, int enc);
void DES_ncbc_encrypt(const unsigned char *input, unsigned char *output,
	long length, DES_key_schedule *schedule,
	DES_cblock *ivec, int enc);
void DES_xcbc_encrypt(const unsigned char *input, unsigned char *output,
	long length, DES_key_schedule *schedule,
	DES_cblock *ivec, const_DES_cblock *inw,
	const_DES_cblock *outw, int enc);
void DES_cfb_encrypt(const unsigned char *in, unsigned char *out, int numbits,
	long length, DES_key_schedule *schedule,
	DES_cblock *ivec, int enc);
void DES_ecb_encrypt(const_DES_cblock *input, DES_cblock *output,
	DES_key_schedule *ks, int enc);
void DES_encrypt1(DES_LONG *data, DES_key_schedule *ks, int enc);
void DES_encrypt2(DES_LONG *data, DES_key_schedule *ks, int enc);
void DES_encrypt3(DES_LONG *data, DES_key_schedule *ks1,
	DES_key_schedule *ks2, DES_key_schedule *ks3);
void DES_ede3_cbc_encrypt(const unsigned char *input, unsigned char *output,
	long length,
	DES_key_schedule *ks1, DES_key_schedule *ks2,
	DES_key_schedule *ks3, DES_cblock *ivec, int enc);
void DES_ede3_cfb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, DES_key_schedule *ks1,
	DES_key_schedule *ks2, DES_key_schedule *ks3,
	DES_cblock *ivec, int *num, int enc);
void DES_ede3_cfb_encrypt(const unsigned char *in, unsigned char *out,
	int numbits, long length, DES_key_schedule *ks1,
	DES_key_schedule *ks2, DES_key_schedule *ks3,
	DES_cblock *ivec, int enc);
void DES_ede3_ofb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, DES_key_schedule *ks1,
	DES_key_schedule *ks2, DES_key_schedule *ks3,
	DES_cblock *ivec, int *num);
void DES_ofb_encrypt(const unsigned char *in, unsigned char *out, int numbits,
	long length, DES_key_schedule *schedule,
	DES_cblock *ivec);
void DES_pcbc_encrypt(const unsigned char *input, unsigned char *output,
	long length, DES_key_schedule *schedule,
	DES_cblock *ivec, int enc);
void DES_cfb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, DES_key_schedule *schedule,
	DES_cblock *ivec, int *num, int enc);
void DES_ofb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, DES_key_schedule *schedule,
	DES_cblock *ivec, int *num);
void IDEA_ecb_encrypt(const unsigned char *in, unsigned char *out,
	IDEA_KEY_SCHEDULE *ks);
void IDEA_set_encrypt_key(const unsigned char *key, IDEA_KEY_SCHEDULE *ks);
void IDEA_cbc_encrypt(const unsigned char *in, unsigned char *out,
	long length, IDEA_KEY_SCHEDULE *ks, unsigned char *iv,
	int enc);
void IDEA_cfb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, IDEA_KEY_SCHEDULE *ks, unsigned char *iv,
	int *num, int enc);
void IDEA_ofb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, IDEA_KEY_SCHEDULE *ks, unsigned char *iv,
	int *num);
void IDEA_encrypt(unsigned long *in, IDEA_KEY_SCHEDULE *ks);
void RC2_ecb_encrypt(const unsigned char *in, unsigned char *out,
	RC2_KEY *key, int enc);
void RC2_encrypt(unsigned long *data, RC2_KEY *key);
void RC2_cbc_encrypt(const unsigned char *in, unsigned char *out, long length,
	RC2_KEY *ks, unsigned char *iv, int enc);
void RC2_cfb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, RC2_KEY *schedule, unsigned char *ivec,
	int *num, int enc);
void RC2_ofb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, RC2_KEY *schedule, unsigned char *ivec,
	int *num);
void RC5_32_ecb_encrypt(const unsigned char *in, unsigned char *out,
	RC5_32_KEY *key, int enc);
void RC5_32_encrypt(unsigned long *data, RC5_32_KEY *key);
void RC5_32_cbc_encrypt(const unsigned char *in, unsigned char *out,
	long length, RC5_32_KEY *ks, unsigned char *iv,
	int enc);
void RC5_32_cfb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, RC5_32_KEY *schedule,
	unsigned char *ivec, int *num, int enc);
void RC5_32_ofb64_encrypt(const unsigned char *in, unsigned char *out,
	long length, RC5_32_KEY *schedule,
	unsigned char *ivec, int *num);
void RC4_set_key(RC4_KEY *key, int len, const unsigned char *data);
void RC4(RC4_KEY *key, size_t len, const unsigned char *indata,
	unsigned char *outdata);
