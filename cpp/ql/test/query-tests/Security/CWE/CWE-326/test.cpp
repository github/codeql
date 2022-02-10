

typedef int EVP_CIPHER;
typedef int EVP_MD;

const EVP_CIPHER *EVP_aes_128_ctr();
const EVP_CIPHER *EVP_aes_192_ctr();
const EVP_CIPHER *EVP_aes_256_ctr();

const EVP_MD *EVP_sha224();
const EVP_MD *EVP_sha256();
const EVP_MD *EVP_sha384();
const EVP_MD *EVP_sha512();


class EVP_PKEY_CTX;

 // int is a curve ID rather than a bit width
int EVP_PKEY_CTX_set_ec_paramgen_curve_nid(EVP_PKEY_CTX*, int);

int EVP_PKEY_CTX_set_dsa_paramgen_bits(EVP_PKEY_CTX*, int);
int EVP_PKEY_CTX_set_dh_paramgen_prime_len(EVP_PKEY_CTX*, int);

// RSA sets bits per-key rather than with parameters
int EVP_PKEY_CTX_set_rsa_keygen_bits(EVP_PKEY_CTX*, int);

void test1(EVP_PKEY_CTX *ctx) {
    EVP_PKEY_CTX_set_dsa_paramgen_bits(ctx, 2048);
    EVP_PKEY_CTX_set_dh_paramgen_prime_len(ctx, 2048);
    // RSA sets bits per-key rather than with parameters
    EVP_PKEY_CTX_set_rsa_keygen_bits(ctx, 2048);

    // low key sizes
    EVP_PKEY_CTX_set_dsa_paramgen_bits(ctx, 1024);
    EVP_PKEY_CTX_set_dh_paramgen_prime_len(ctx, 1024);
    // RSA sets bits per-key rather than with parameters
    EVP_PKEY_CTX_set_rsa_keygen_bits(ctx, 1024);
}