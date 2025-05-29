#ifndef USE_REAL_HEADERS
#include "../includes/evp_stubs.h"
#include "../includes/alg_macro_stubs.h"
#include "../includes/rand_stubs.h"
#else
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/rsa.h>
#include <openssl/dsa.h>
#include <openssl/pem.h>
#endif

/* =============================================================================
 * UTILITY FUNCTIONS - Common operations shared across signature APIs
 * =============================================================================
 */

/**
 * Create message digest from raw message data
 */
static int create_digest(const unsigned char *message, size_t message_len,
                        const EVP_MD *md, unsigned char *digest, unsigned int *digest_len) {
    EVP_MD_CTX *md_ctx = EVP_MD_CTX_new();
    int ret = 0;
    
    if (!md_ctx || 
        EVP_DigestInit_ex(md_ctx, md, NULL) != 1 ||
        EVP_DigestUpdate(md_ctx, message, message_len) != 1 ||
        EVP_DigestFinal_ex(md_ctx, digest, digest_len) != 1) {
        goto cleanup;
    }
    ret = 1;

cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/**
 * Allocate signature buffer with appropriate size
 */
static unsigned char* allocate_signature_buffer(size_t *sig_len, const EVP_PKEY *pkey) {
    *sig_len = EVP_PKEY_size(pkey);
    return OPENSSL_malloc(*sig_len);
}

/**
 * Helper to extract key from EVP_PKEY
 */
static RSA* get_rsa_from_pkey(EVP_PKEY *pkey) {
    return EVP_PKEY_get1_RSA(pkey);
}

static DSA* get_dsa_from_pkey(EVP_PKEY *pkey) {
    return EVP_PKEY_get1_DSA(pkey);
}

/* =============================================================================
 * EVP_SIGN/VERIFY API - Legacy high-level API (older, simpler)
 * =============================================================================
 */

/**
 * Sign message using EVP_Sign API (legacy)
 * Simple API with built-in hashing and signing
 */
int sign_using_evp_sign(const unsigned char *message, size_t message_len,
                        unsigned char **signature, size_t *signature_len,
                        EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_MD_CTX *md_ctx = NULL;
    unsigned int sig_len = 0;
    int ret = 0;
    
    if (!(md_ctx = EVP_MD_CTX_new()) ||
        EVP_SignInit(md_ctx, md) != 1 ||
        EVP_SignUpdate(md_ctx, message, message_len) != 1) {
        goto cleanup;
    }
    
    *signature = allocate_signature_buffer(signature_len, pkey);
    if (!*signature) goto cleanup;
    
    if (EVP_SignFinal(md_ctx, *signature, &sig_len, pkey) == 1) {
        *signature_len = sig_len;
        ret = 1;
    } else {
        OPENSSL_free(*signature);
        *signature = NULL;
    }
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/**
 * Verify signature using EVP_Verify API (legacy)
 * Simple API with built-in hashing and verification
 */
int verify_using_evp_verify(const unsigned char *message, size_t message_len,
                           const unsigned char *signature, size_t signature_len,
                           EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_MD_CTX *md_ctx = NULL;
    int ret = 0;
    
    if (!(md_ctx = EVP_MD_CTX_new()) ||
        EVP_VerifyInit(md_ctx, md) != 1 ||
        EVP_VerifyUpdate(md_ctx, message, message_len) != 1 ||
        EVP_VerifyFinal(md_ctx, signature, (unsigned int)signature_len, pkey) != 1) {
        goto cleanup;
    }
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/* =============================================================================
 * EVP_DIGESTSIGN/DIGESTVERIFY API - Modern recommended API 
 * =============================================================================
 */

/**
 * Sign message using EVP_DigestSign API (recommended)
 * Modern flexible API with better algorithm support
 */
int sign_using_evp_digestsign(const unsigned char *message, size_t message_len,
                              unsigned char **signature, size_t *signature_len,
                              EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_MD_CTX *md_ctx = NULL;
    int ret = 0;
    
    if (!(md_ctx = EVP_MD_CTX_new()) ||
        EVP_DigestSignInit(md_ctx, NULL, md, NULL, pkey) != 1 ||
        EVP_DigestSignUpdate(md_ctx, message, message_len) != 1 ||
        EVP_DigestSignFinal(md_ctx, NULL, signature_len) != 1) {
        goto cleanup;
    }
    
    *signature = OPENSSL_malloc(*signature_len);
    if (!*signature) goto cleanup;
    
    if (EVP_DigestSignFinal(md_ctx, *signature, signature_len) == 1) {
        ret = 1;
    } else {
        OPENSSL_free(*signature);
        *signature = NULL;
    }
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/**
 * Verify signature using EVP_DigestVerify API (recommended)
 * Modern flexible API with better algorithm support
 */
int verify_using_evp_digestverify(const unsigned char *message, size_t message_len,
                                 const unsigned char *signature, size_t signature_len,
                                 EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_MD_CTX *md_ctx = NULL;
    int ret = 0;
    
    if (!(md_ctx = EVP_MD_CTX_new()) ||
        EVP_DigestVerifyInit(md_ctx, NULL, md, NULL, pkey) != 1 ||
        EVP_DigestVerifyUpdate(md_ctx, message, message_len) != 1 ||
        EVP_DigestVerifyFinal(md_ctx, signature, signature_len) != 1) {
        goto cleanup;
    }
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/**
 * Sign with explicit PKEY_CTX for fine-grained parameter control
 * Allows custom parameter settings (e.g., padding, salt length)
 */
int sign_using_digestsign_with_ctx(const unsigned char *message, size_t message_len,
                                  unsigned char **signature, size_t *signature_len,
                                  EVP_PKEY *pkey, const EVP_MD *md, 
                                  int (*param_setter)(EVP_PKEY_CTX *ctx)) {
    EVP_MD_CTX *md_ctx = NULL;
    EVP_PKEY_CTX *pkey_ctx = NULL;
    int ret = 0;
    
    if (!(md_ctx = EVP_MD_CTX_new()) ||
        EVP_DigestSignInit(md_ctx, &pkey_ctx, md, NULL, pkey) != 1) {
        goto cleanup;
    }
    
    if (param_setter && param_setter(pkey_ctx) != 1) goto cleanup;
    
    if (EVP_DigestSignUpdate(md_ctx, message, message_len) != 1 ||
        EVP_DigestSignFinal(md_ctx, NULL, signature_len) != 1) {
        goto cleanup;
    }
    
    *signature = OPENSSL_malloc(*signature_len);
    if (!*signature) goto cleanup;
    
    if (EVP_DigestSignFinal(md_ctx, *signature, signature_len) == 1) {
        ret = 1;
    } else {
        OPENSSL_free(*signature);
        *signature = NULL;
    }
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/**
 * Verify with explicit PKEY_CTX for fine-grained parameter control
 */
int verify_using_digestverify_with_ctx(const unsigned char *message, size_t message_len,
                                      const unsigned char *signature, size_t signature_len,
                                      EVP_PKEY *pkey, const EVP_MD *md,
                                      int (*param_setter)(EVP_PKEY_CTX *ctx)) {
    EVP_MD_CTX *md_ctx = NULL;
    EVP_PKEY_CTX *pkey_ctx = NULL;
    int ret = 0;
    
    if (!(md_ctx = EVP_MD_CTX_new()) ||
        EVP_DigestVerifyInit(md_ctx, &pkey_ctx, md, NULL, pkey) != 1) {
        goto cleanup;
    }
    
    if (param_setter && param_setter(pkey_ctx) != 1) goto cleanup;
    
    if (EVP_DigestVerifyUpdate(md_ctx, message, message_len) != 1 ||
        EVP_DigestVerifyFinal(md_ctx, signature, signature_len) != 1) {
        goto cleanup;
    }
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/* =============================================================================
 * EVP_PKEY_SIGN/VERIFY API - Lower level API with pre-hashed input
 * =============================================================================
 */

/**
 * Sign pre-hashed digest using EVP_PKEY_sign API
 * Lower-level API requiring pre-computed digest
 */
int sign_using_evp_pkey_sign(const unsigned char *digest, size_t digest_len,
                             unsigned char **signature, size_t *signature_len,
                             EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_PKEY_CTX *pkey_ctx = NULL;
    int ret = 0;
    
    if (!(pkey_ctx = EVP_PKEY_CTX_new(pkey, NULL)) ||
        EVP_PKEY_sign_init(pkey_ctx) != 1 ||
        EVP_PKEY_CTX_set_signature_md(pkey_ctx, md) != 1 ||
        EVP_PKEY_sign(pkey_ctx, NULL, signature_len, digest, digest_len) != 1) {
        goto cleanup;
    }
    
    *signature = OPENSSL_malloc(*signature_len);
    if (!*signature) goto cleanup;
    
    if (EVP_PKEY_sign(pkey_ctx, *signature, signature_len, digest, digest_len) == 1) {
        ret = 1;
    } else {
        OPENSSL_free(*signature);
        *signature = NULL;
    }
    
cleanup:
    EVP_PKEY_CTX_free(pkey_ctx);
    return ret;
}

/**
 * Verify pre-hashed digest using EVP_PKEY_verify API
 * Lower-level API requiring pre-computed digest
 */
int verify_using_evp_pkey_verify(const unsigned char *digest, size_t digest_len,
                                const unsigned char *signature, size_t signature_len,
                                EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_PKEY_CTX *pkey_ctx = NULL;
    int ret = 0;
    
    if (!(pkey_ctx = EVP_PKEY_CTX_new(pkey, NULL)) ||
        EVP_PKEY_verify_init(pkey_ctx) != 1 ||
        EVP_PKEY_CTX_set_signature_md(pkey_ctx, md) != 1 ||
        EVP_PKEY_verify(pkey_ctx, signature, signature_len, digest, digest_len) != 1) {
        goto cleanup;
    }
    ret = 1;
    
cleanup:
    EVP_PKEY_CTX_free(pkey_ctx);
    return ret;
}

/* =============================================================================
 * EVP_PKEY_SIGN_MESSAGE API - Streamlined message signing
 * =============================================================================
 */

/**
 * Sign message using EVP_PKEY_sign_message API
 * Streamlined interface for direct message signing
 */
int sign_using_evp_pkey_sign_message(const unsigned char *message, size_t message_len,
                                     unsigned char **signature, size_t *signature_len,
                                     EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_PKEY_CTX *pkey_ctx = NULL;
    EVP_SIGNATURE *alg = NULL;
    int ret = 0;

    if (!(pkey_ctx = EVP_PKEY_CTX_new(pkey, NULL))) goto cleanup;
    
    alg = EVP_SIGNATURE_fetch(NULL, "RSA-SHA256", NULL);
    
    if (EVP_PKEY_sign_message_init(pkey_ctx, alg, NULL) != 1 ||
        EVP_PKEY_sign_message_update(pkey_ctx, message, message_len) != 1 ||
        EVP_PKEY_sign_message_final(pkey_ctx, NULL, signature_len) != 1) {
        goto cleanup;
    }
    
    *signature = OPENSSL_malloc(*signature_len);
    if (!*signature) goto cleanup;
    
    if (EVP_PKEY_sign_message_final(pkey_ctx, *signature, signature_len) == 1) {
        ret = 1;
    } else {
        OPENSSL_free(*signature);
        *signature = NULL;
    }
    
cleanup:
    EVP_PKEY_CTX_free(pkey_ctx);
    return ret;
}

/**
 * Verify message using EVP_PKEY_verify_message API
 * Streamlined interface for direct message verification
 */
int verify_using_evp_pkey_verify_message(const unsigned char *message, size_t message_len,
                                        const unsigned char *signature, size_t signature_len,
                                        EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_PKEY_CTX *pkey_ctx = NULL;
    EVP_SIGNATURE *alg = NULL;
    int ret = 0;

    if (!(pkey_ctx = EVP_PKEY_CTX_new(pkey, NULL))) goto cleanup;
    
    alg = EVP_SIGNATURE_fetch(NULL, "RSA-SHA256", NULL);
    
    if (EVP_PKEY_verify_message_init(pkey_ctx, alg, NULL) != 1) goto cleanup;
    
    EVP_PKEY_CTX_set_signature(pkey_ctx, signature, signature_len);
    
    if (EVP_PKEY_verify_message_update(pkey_ctx, message, message_len) != 1 ||
        EVP_PKEY_verify_message_final(pkey_ctx) != 1) {
        goto cleanup;
    }
    ret = 1;
    
cleanup:
    EVP_PKEY_CTX_free(pkey_ctx);
    return ret;
}

/* =============================================================================
 * LOW-LEVEL RSA API - Algorithm-specific functions (deprecated)
 * =============================================================================
 */

/**
 * Sign using low-level RSA_sign API (deprecated, RSA-only)
 * Direct RSA signing with manual digest computation
 */
int sign_using_rsa_sign(const unsigned char *message, size_t message_len,
                       unsigned char **signature, size_t *signature_len,
                       RSA *rsa_key, int hash_nid, const EVP_MD *md) {
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    int ret = 0;
    
    if (!create_digest(message, message_len, md, digest, &digest_len)) return 0;
    
    *signature_len = RSA_size(rsa_key);
    *signature = OPENSSL_malloc(*signature_len);
    if (!*signature) return 0;
    
    if (RSA_sign(hash_nid, digest, digest_len, *signature, 
                 (unsigned int*)signature_len, rsa_key) == 1) {
        ret = 1;
    } else {
        OPENSSL_free(*signature);
        *signature = NULL;
    }
    
    return ret;
}

/**
 * Verify using low-level RSA_verify API (deprecated, RSA-only)
 * Direct RSA verification with manual digest computation
 */
int verify_using_rsa_verify(const unsigned char *message, size_t message_len,
                           const unsigned char *signature, size_t signature_len,
                           RSA *rsa_key, int hash_nid, const EVP_MD *md) {
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    
    if (!create_digest(message, message_len, md, digest, &digest_len)) return 0;
    
    return RSA_verify(hash_nid, digest, digest_len, signature, 
                     (unsigned int)signature_len, rsa_key);
}

/* =============================================================================
 * LOW-LEVEL DSA API - Algorithm-specific functions (deprecated)
 * =============================================================================
 */

/**
 * Sign using low-level DSA_do_sign API (deprecated, DSA-only)
 * Direct DSA signing with manual digest and signature encoding
 */
int sign_using_dsa_sign(const unsigned char *message, size_t message_len,
                       unsigned char **signature, size_t *signature_len,
                       DSA *dsa_key, const EVP_MD *md) {
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    DSA_SIG *sig = NULL;
    const BIGNUM *r = NULL, *s = NULL;
    unsigned int bn_len;
    int ret = 0;
    
    if (!create_digest(message, message_len, md, digest, &digest_len)) return 0;
    
    sig = DSA_do_sign(digest, digest_len, dsa_key);
    if (!sig) return 0;
    
    DSA_SIG_get0(sig, &r, &s);
    if (!r || !s) goto cleanup;
    
    bn_len = DSA_size(dsa_key) / 2;
    *signature_len = DSA_size(dsa_key);
    *signature = OPENSSL_malloc(*signature_len);
    if (!*signature) goto cleanup;
    
    memset(*signature, 0, *signature_len);
    
    if (BN_bn2bin(r, *signature + (bn_len - BN_num_bytes(r))) > 0 &&
        BN_bn2bin(s, *signature + bn_len + (bn_len - BN_num_bytes(s))) > 0) {
        ret = 1;
    } else {
        OPENSSL_free(*signature);
        *signature = NULL;
    }
    
cleanup:
    DSA_SIG_free(sig);
    return ret;
}

/**
 * Verify using low-level DSA_do_verify API (deprecated, DSA-only)
 * Direct DSA verification with manual digest and signature decoding
 */
int verify_using_dsa_verify(const unsigned char *message, size_t message_len,
                           const unsigned char *signature, size_t signature_len,
                           DSA *dsa_key, const EVP_MD *md) {
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    DSA_SIG *sig = NULL;
    BIGNUM *r = NULL, *s = NULL;
    unsigned int bn_len;
    int ret = 0;
    
    if (!create_digest(message, message_len, md, digest, &digest_len)) return 0;
    
    sig = DSA_SIG_new();
    if (!sig) return 0;
    
    r = BN_new();
    s = BN_new();
    if (!r || !s) goto cleanup;
    
    bn_len = DSA_size(dsa_key) / 2;
    
    if (BN_bin2bn(signature, bn_len, r) &&
        BN_bin2bn(signature + bn_len, bn_len, s) &&
        DSA_SIG_set0(sig, r, s) == 1) {
        /* r and s are now owned by sig */
        r = s = NULL;
        ret = DSA_do_verify(digest, digest_len, sig, dsa_key);
    }
    
cleanup:
    DSA_SIG_free(sig);
    BN_free(r);
    BN_free(s);
    return (ret == 1);
}

/* =============================================================================
 * PARAMETER SETTERS - Helper functions for algorithm configuration
 * =============================================================================
 */

/**
 * Set RSA PSS padding mode
 */
int set_rsa_pss_padding(EVP_PKEY_CTX *ctx) {
    return EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_PSS_PADDING);
}

/**
 * No-op parameter setter for default behavior
 */
int no_parameter_setter(EVP_PKEY_CTX *ctx) {
    return 1;
}

/* =============================================================================
 * KEY GENERATION HELPERS
 * =============================================================================
 */

/**
 * Generate RSA key pair for testing
 */
static EVP_PKEY* generate_rsa_key(void) {
    EVP_PKEY_CTX *key_ctx = NULL;
    EVP_PKEY *key = NULL;
    
    key_ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_RSA, NULL);
    if (!key_ctx) return NULL;
    
    if (EVP_PKEY_keygen_init(key_ctx) <= 0 ||
        EVP_PKEY_CTX_set_rsa_keygen_bits(key_ctx, 2048) <= 0 ||
        EVP_PKEY_keygen(key_ctx, &key) <= 0) {
        EVP_PKEY_free(key);
        key = NULL;
    }
    
    EVP_PKEY_CTX_free(key_ctx);
    return key;
}

/**
 * Generate DSA key pair for testing
 */
static EVP_PKEY* generate_dsa_key(void) {
    EVP_PKEY_CTX *param_ctx = NULL, *key_ctx = NULL;
    EVP_PKEY *params = NULL, *key = NULL;
    
    /* Generate parameters first */
    param_ctx = EVP_PKEY_CTX_new_from_name(NULL, "DSA", NULL);
    if (!param_ctx) return NULL;
    
    if (EVP_PKEY_paramgen_init(param_ctx) <= 0 ||
        EVP_PKEY_CTX_set_dsa_paramgen_bits(param_ctx, 2048) <= 0 ||
        EVP_PKEY_paramgen(param_ctx, &params) <= 0) {
        goto cleanup;
    }
    
    /* Generate key using parameters */
    key_ctx = EVP_PKEY_CTX_new(params, NULL);
    if (!key_ctx ||
        EVP_PKEY_keygen_init(key_ctx) <= 0 ||
        EVP_PKEY_keygen(key_ctx, &key) <= 0) {
        EVP_PKEY_free(key);
        key = NULL;
    }
    
cleanup:
    EVP_PKEY_CTX_free(param_ctx);
    EVP_PKEY_CTX_free(key_ctx);
    EVP_PKEY_free(params);
    return key;
}

/* =============================================================================
 * TEST FUNCTIONS - Comprehensive API testing
 * =============================================================================
 */

/**
 * Test all signature APIs with a given key and algorithm
 * Demonstrates the 6 different signature API approaches
 */
int test_signature_apis(EVP_PKEY *key, const EVP_MD *md, 
                       int (*param_setter)(EVP_PKEY_CTX *ctx),
                       const char *algo_name) {
    const unsigned char message[] = "Test message for OpenSSL signature APIs";
    const size_t message_len = strlen((char *)message);
    
    unsigned char *sig1 = NULL, *sig2 = NULL, *sig3 = NULL, 
                  *sig4 = NULL, *sig6 = NULL;
    size_t sig_len1 = 0, sig_len2 = 0, sig_len3 = 0, sig_len4 = 0, sig_len6 = 0;
    
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    int success = 1;
    
    printf("\nTesting signature APIs with %s:\n", algo_name);
    
    /* Test 1: EVP_Sign API */
    printf("1. EVP_Sign API: ");
    if (sign_using_evp_sign(message, message_len, &sig1, &sig_len1, key, md) &&
        verify_using_evp_verify(message, message_len, sig1, sig_len1, key, md)) {
        printf("PASS\n");
    } else {
        printf("FAIL\n");
        success = 0;
    }
    
    /* Test 2: EVP_DigestSign API */
    printf("2. EVP_DigestSign API: ");
    if (sign_using_evp_digestsign(message, message_len, &sig2, &sig_len2, key, md) &&
        verify_using_evp_digestverify(message, message_len, sig2, sig_len2, key, md)) {
        printf("PASS\n");
    } else {
        printf("FAIL\n");
        success = 0;
    }
    
    /* Test 3: EVP_PKEY_sign API (requires pre-hashed input) */
    printf("3. EVP_PKEY_sign API: ");
    if (create_digest(message, message_len, md, digest, &digest_len) &&
        sign_using_evp_pkey_sign(digest, digest_len, &sig3, &sig_len3, key, md) &&
        verify_using_evp_pkey_verify(digest, digest_len, sig3, sig_len3, key, md)) {
        printf("PASS\n");
    } else {
        printf("FAIL\n");
        success = 0;
    }
    
    /* Test 4: EVP_DigestSign with explicit PKEY_CTX */
    printf("4. EVP_DigestSign with explicit PKEY_CTX: ");
    if (sign_using_digestsign_with_ctx(message, message_len, &sig4, &sig_len4, 
                                      key, md, param_setter) &&
        verify_using_digestverify_with_ctx(message, message_len, sig4, sig_len4, 
                                          key, md, param_setter)) {
        printf("PASS\n");
    } else {
        printf("FAIL\n");
        success = 0;
    }
    
    /* Test 6: EVP_PKEY_sign_message API */
    printf("6. EVP_PKEY_sign_message API: ");
    if (sign_using_evp_pkey_sign_message(message, message_len, &sig6, &sig_len6, key, md) &&
        verify_using_evp_pkey_verify_message(message, message_len, sig6, sig_len6, key, md)) {
        printf("PASS\n");
    } else {
        printf("FAIL\n");
        success = 0;
    }
    
    /* Cleanup */
    OPENSSL_free(sig1);
    OPENSSL_free(sig2);
    OPENSSL_free(sig3);
    OPENSSL_free(sig4);
    OPENSSL_free(sig6);
    
    return success;
}

/**
 * Test RSA-specific signature APIs including low-level RSA functions
 */
int test_signature_apis_rsa(void) {
    EVP_PKEY *key = NULL;
    RSA *rsa_key = NULL;
    const EVP_MD *md = EVP_sha256();
    const unsigned char message[] = "Test message for OpenSSL signature APIs";
    const size_t message_len = strlen((char *)message);
    unsigned char *sig5 = NULL;
    size_t sig_len5 = 0;
    int success = 1;
    
    printf("\nGenerating RSA key pair...\n");
    key = generate_rsa_key();
    if (!key) return 0;
    
    rsa_key = get_rsa_from_pkey(key);
    if (!rsa_key) {
        EVP_PKEY_free(key);
        return 0;
    }
    
    /* Test generic APIs */
    if (!test_signature_apis(key, md, set_rsa_pss_padding, "RSA")) {
        success = 0;
    }
    
    /* Test 5: Low-level RSA API */
    printf("5. Low-level RSA API: ");
    if (sign_using_rsa_sign(message, message_len, &sig5, &sig_len5, 
                           rsa_key, NID_sha256, md) &&
        verify_using_rsa_verify(message, message_len, sig5, sig_len5, 
                               rsa_key, NID_sha256, md)) {
        printf("PASS\n");
    } else {
        printf("FAIL\n");
        success = 0;
    }
    
    printf("\nRSA API Summary:\n");
    printf("1. EVP_Sign API: Legacy, simple\n");
    printf("2. EVP_DigestSign API: Modern, recommended\n");
    printf("3. EVP_PKEY_sign API: Lower-level, pre-hashed input\n");
    printf("4. EVP_DigestSign with PKEY_CTX: Fine-grained control\n");
    printf("5. Low-level RSA API: Deprecated, algorithm-specific\n");
    printf("6. EVP_PKEY_sign_message API: Streamlined message signing\n");
    
    /* Cleanup */
    OPENSSL_free(sig5);
    RSA_free(rsa_key);
    EVP_PKEY_free(key);
    
    return success;
}

/**
 * Test DSA-specific signature APIs including low-level DSA functions
 */
int test_signature_apis_dsa(void) {
    EVP_PKEY *key = NULL;
    DSA *dsa_key = NULL;
    const EVP_MD *md = EVP_sha256();
    const unsigned char message[] = "Test message for OpenSSL signature APIs";
    const size_t message_len = strlen((char *)message);
    unsigned char *sig5 = NULL;
    size_t sig_len5 = 0;
    int success = 1;
    
    printf("\nGenerating DSA key pair...\n");
    key = generate_dsa_key();
    if (!key) return 0;
    
    dsa_key = get_dsa_from_pkey(key);
    if (!dsa_key) {
        EVP_PKEY_free(key);
        return 0;
    }
    
    /* Test generic APIs */
    if (!test_signature_apis(key, md, no_parameter_setter, "DSA")) {
        success = 0;
    }
    
    /* Test 5: Low-level DSA API */
    printf("5. Low-level DSA API: ");
    if (sign_using_dsa_sign(message, message_len, &sig5, &sig_len5, dsa_key, md) &&
        verify_using_dsa_verify(message, message_len, sig5, sig_len5, dsa_key, md)) {
        printf("PASS\n");
    } else {
        printf("FAIL\n");
        success = 0;
    }
    
    printf("\nDSA API Summary:\n");
    printf("1. EVP_Sign API: Legacy, simple\n");
    printf("2. EVP_DigestSign API: Modern, recommended\n");
    printf("3. EVP_PKEY_sign API: Lower-level, pre-hashed input\n");
    printf("4. EVP_DigestSign with PKEY_CTX: Fine-grained control\n");
    printf("5. Low-level DSA API: Deprecated, algorithm-specific\n");
    printf("6. EVP_PKEY_sign_message API: Streamlined message signing\n");
    
    /* Cleanup */
    OPENSSL_free(sig5);
    EVP_PKEY_free(key);
    
    return success;
}

/* =============================================================================
 * MAIN FUNCTION - Entry point for testing all signature APIs
 * =============================================================================
 */

/**
 * Main function demonstrating all OpenSSL signature APIs
 * Tests both RSA and DSA algorithms with all 6 API approaches
 */
int main(void) {
    /* Initialize OpenSSL */
    OpenSSL_add_all_algorithms();
    ERR_load_crypto_strings();
    
    printf("=================================================================\n");
    printf("OpenSSL Signature API Demonstration\n");
    printf("=================================================================\n");
    
    printf("\n-------- TESTING RSA SIGNATURES --------\n");
    int rsa_result = test_signature_apis_rsa();
    
    printf("\n-------- TESTING DSA SIGNATURES --------\n");
    int dsa_result = test_signature_apis_dsa();
    
    printf("\n=================================================================\n");
    if (rsa_result && dsa_result) {
        printf("All tests completed successfully.\n");
        return 0;
    } else {
        printf("Some tests failed.\n");
        return 1;
    }
}
