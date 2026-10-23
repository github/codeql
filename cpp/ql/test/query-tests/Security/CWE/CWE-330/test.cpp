#include "openssl/evp.h"
#include "openssl/obj_mac.h"
#include "openssl/rand.h"

typedef unsigned long size_t;

// --- C standard library / POSIX / BSD random number generators (declarations) ---
extern "C" {
// Not cryptographically secure.
int rand(void);
long random(void);
double drand48(void);
double erand48(unsigned short xsubi[3]);
long lrand48(void);
long nrand48(unsigned short xsubi[3]);
long mrand48(void);
long jrand48(unsigned short xsubi[3]);
int rand_r(unsigned int *seedp);
// Cryptographically secure.
unsigned int arc4random(void);
unsigned int arc4random_uniform(unsigned int upper_bound);
void arc4random_buf(void *buf, size_t nbytes);
int getrandom(void *buf, size_t buflen, unsigned int flags);
int getentropy(void *buffer, size_t length);
}

// --- Windows CryptoAPI / CNG (cryptographically secure, simplified signatures) ---
typedef unsigned long DWORD;
typedef int BOOL;
typedef unsigned char BYTE;
typedef void *HCRYPTPROV;
typedef long NTSTATUS;
typedef void *BCRYPT_ALG_HANDLE;
typedef unsigned long ULONG;
typedef unsigned char BOOLEAN;
BOOLEAN RtlGenRandom(void *RandomBuffer, ULONG RandomBufferLength);
BOOL CryptGenRandom(HCRYPTPROV hProv, DWORD dwLen, BYTE *pbBuffer);
NTSTATUS BCryptGenRandom(BCRYPT_ALG_HANDLE hAlgorithm, unsigned char *pbBuffer, ULONG cbBuffer,
                         ULONG dwFlags);

// --- C++ <random> engines (faithful subset of the standard library) ---
namespace std {
int rand(void);

template<class UIntType, UIntType a, UIntType c, UIntType m>
class linear_congruential_engine {
public:
  typedef UIntType result_type;
  linear_congruential_engine();
  result_type operator()();
};

template<class UIntType, unsigned w, unsigned n, unsigned m, unsigned r, UIntType a, unsigned u,
         UIntType d, unsigned s, UIntType b, unsigned t, UIntType cc, unsigned l, UIntType f>
class mersenne_twister_engine {
public:
  typedef UIntType result_type;
  mersenne_twister_engine();
  result_type operator()();
};

template<class UIntType, unsigned w, unsigned s, unsigned r>
class subtract_with_carry_engine {
public:
  typedef UIntType result_type;
  subtract_with_carry_engine();
  result_type operator()();
};

template<class Engine, unsigned p, unsigned r>
class discard_block_engine {
public:
  typedef typename Engine::result_type result_type;
  discard_block_engine();
  result_type operator()();
};

template<class Engine, unsigned k>
class shuffle_order_engine {
public:
  typedef typename Engine::result_type result_type;
  shuffle_order_engine();
  result_type operator()();
};

template<class Engine, unsigned w, class UIntType>
class independent_bits_engine {
public:
  typedef UIntType result_type;
  independent_bits_engine();
  result_type operator()();
};

typedef mersenne_twister_engine<unsigned long, 32, 624, 397, 31, 0x9908b0dfUL, 11, 0xffffffffUL, 7,
                                0x9d2c5680UL, 15, 0xefc60000UL, 18, 1812433253UL> mt19937;
typedef mersenne_twister_engine<unsigned long long, 64, 312, 156, 31, 0xb5026f5aa96619e9ULL, 29,
                                0x5555555555555555ULL, 17, 0x71d67fffeda60000ULL, 37,
                                0xfff7eee000000000ULL, 43, 6364136223846793005ULL> mt19937_64;
typedef linear_congruential_engine<unsigned long, 16807, 0, 2147483647> minstd_rand0;
typedef linear_congruential_engine<unsigned long, 48271, 0, 2147483647> minstd_rand;
typedef subtract_with_carry_engine<unsigned long, 24, 10, 24> ranlux24_base;
typedef subtract_with_carry_engine<unsigned long, 48, 5, 12> ranlux48_base;
typedef discard_block_engine<ranlux24_base, 223, 23> ranlux24;
typedef discard_block_engine<ranlux48_base, 389, 11> ranlux48;
typedef shuffle_order_engine<minstd_rand0, 256> knuth_b;
typedef minstd_rand0 default_random_engine;

class random_device {
public:
  typedef unsigned int result_type;
  random_device();
  result_type operator()();
};
}

// Run an OpenSSL cipher operation so the key/IV arguments of `EVP_EncryptInit_ex`
// become key/nonce consumers. `finish` provides the (dominated) final step.
static void finish(EVP_CIPHER_CTX *ctx) {
  unsigned char in[16] = {0};
  unsigned char out[64];
  int outlen = 0;
  EVP_EncryptUpdate(ctx, out, &outlen, in, 16);
  EVP_EncryptFinal_ex(ctx, out, &outlen);
}

// ===========================================================================
// Insecure generators feeding a cipher key (positive).
// ===========================================================================

void test_rand() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = (unsigned char)rand(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_std_rand() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = (unsigned char)std::rand(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_random() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = (unsigned char)random(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_drand48() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = (unsigned char)drand48(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_erand48() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned short s[3] = {0};
  unsigned char k = (unsigned char)erand48(s); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_lrand48() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = (unsigned char)lrand48(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_nrand48() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned short s[3] = {0};
  unsigned char k = (unsigned char)nrand48(s); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_mrand48() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = (unsigned char)mrand48(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_jrand48() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned short s[3] = {0};
  unsigned char k = (unsigned char)jrand48(s); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_rand_r() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned int seed = 0;
  unsigned char k = (unsigned char)rand_r(&seed); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

// ===========================================================================
// Insecure output reaching an IV (nonce) sink and a raw MAC key sink (positive).
// ===========================================================================

void test_rand_iv() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char key[16] = {0};
  unsigned char iv = (unsigned char)rand(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, key, &iv); // $ Alert
  finish(ctx);
}

void test_rand_mac_key() {
  unsigned char k = (unsigned char)rand(); // $ Source
  EVP_PKEY_new_mac_key(EVP_PKEY_HMAC, 0, &k, 16); // $ Alert
}

// ===========================================================================
// Insecure C++ <random> engines feeding a cipher key (positive).
// ===========================================================================

void test_mt19937() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  std::mt19937 gen;
  unsigned char k = (unsigned char)gen(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_minstd_rand() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  std::minstd_rand gen;
  unsigned char k = (unsigned char)gen(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_ranlux24() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  std::ranlux24 gen;
  unsigned char k = (unsigned char)gen(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_knuth_b() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  std::knuth_b gen;
  unsigned char k = (unsigned char)gen(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_independent_bits_engine() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  std::independent_bits_engine<std::mt19937, 8, unsigned char> gen;
  unsigned char k = (unsigned char)gen(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_default_random_engine() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  std::default_random_engine gen;
  unsigned char k = (unsigned char)gen(); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

// ===========================================================================
// RAND_pseudo_bytes is insecure (positive); RAND_bytes is secure (negative).
// ===========================================================================

void test_rand_pseudo_bytes() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = 0;
  RAND_pseudo_bytes(&k, 1); // $ Source
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv); // $ Alert
  finish(ctx);
}

void test_rand_bytes() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = 0;
  RAND_bytes(&k, 1); // GOOD: cryptographically secure
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}

// ===========================================================================
// Secure generators must NOT be flagged (negative).
// ===========================================================================

void test_arc4random() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = (unsigned char)arc4random(); // GOOD
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}

void test_arc4random_uniform() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = (unsigned char)arc4random_uniform(256); // GOOD
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}

void test_arc4random_buf() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = 0;
  arc4random_buf(&k, 1); // GOOD
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}

void test_getrandom() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = 0;
  getrandom(&k, 1, 0); // GOOD
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}

void test_getentropy() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = 0;
  getentropy(&k, 1); // GOOD
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}

void test_rtlgenrandom() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = 0;
  RtlGenRandom(&k, 1); // GOOD
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}

void test_cryptgenrandom() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = 0;
  CryptGenRandom(0, 1, &k); // GOOD
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}

void test_bcryptgenrandom() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  unsigned char k = 0;
  BCryptGenRandom(0, &k, 1, 0); // GOOD
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}

void test_random_device() {
  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
  unsigned char iv[16] = {0};
  std::random_device rd;
  unsigned char k = (unsigned char)rd(); // GOOD
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, &k, iv);
  finish(ctx);
}
