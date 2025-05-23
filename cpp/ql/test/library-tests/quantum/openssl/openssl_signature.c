#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/rsa.h>
#include <openssl/dsa.h>
#include <openssl/ec.h>
#include <openssl/pem.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/* Helper function to print OpenSSL errors */
void print_openssl_errors(void) {
    unsigned long err;
    char err_buf[256];
    
    while ((err = ERR_get_error()) != 0) {
        ERR_error_string_n(err, err_buf, sizeof(err_buf));
        fprintf(stderr, "OpenSSL error: %s\n", err_buf);
    }
}

/*
 * Pair 1: Using EVP_Sign API (older API)
 * This API is simpler but less flexible
 */

/* Sign a message using EVP_Sign API */
int sign_using_evp_sign(const unsigned char *message, size_t message_len,
                        unsigned char **signature, size_t *signature_len,
                        EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_MD_CTX *md_ctx = NULL;
    int ret = 0;
    unsigned int sig_len = 0;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create EVP_MD_CTX\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Initialize digest operation */
    if (EVP_SignInit(md_ctx, md) != 1) {
        fprintf(stderr, "Failed to initialize signing operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Process the message */
    if (EVP_SignUpdate(md_ctx, message, message_len) != 1) {
        fprintf(stderr, "Failed to update signing operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Allocate memory for signature */
    *signature_len = EVP_PKEY_size(pkey);
    *signature = OPENSSL_malloc(*signature_len);
    if (!(*signature)) {
        fprintf(stderr, "Failed to allocate memory for signature\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Generate signature */
    if (EVP_SignFinal(md_ctx, *signature, &sig_len, pkey) != 1) {
        fprintf(stderr, "Failed to create signature\n");
        print_openssl_errors();
        OPENSSL_free(*signature);
        *signature = NULL;
        goto cleanup;
    }
    
    *signature_len = sig_len;
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/* Verify a signature using EVP_Verify API */
int verify_using_evp_verify(const unsigned char *message, size_t message_len,
                          const unsigned char *signature, size_t signature_len,
                          EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_MD_CTX *md_ctx = NULL;
    int ret = 0;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create EVP_MD_CTX\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Initialize digest operation */
    if (EVP_VerifyInit(md_ctx, md) != 1) {
        fprintf(stderr, "Failed to initialize verification operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Process the message */
    if (EVP_VerifyUpdate(md_ctx, message, message_len) != 1) {
        fprintf(stderr, "Failed to update verification operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Verify the signature */
    if (EVP_VerifyFinal(md_ctx, signature, (unsigned int)signature_len, pkey) != 1) {
        fprintf(stderr, "Signature verification failed\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/*
 * Pair 2: Using EVP_DigestSign API (recommended modern API)
 * This API is more flexible and supports multiple algorithms
 */

/* Sign a message using EVP_DigestSign API */
int sign_using_evp_digestsign(const unsigned char *message, size_t message_len,
                            unsigned char **signature, size_t *signature_len,
                            EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_MD_CTX *md_ctx = NULL;
    int ret = 0;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create EVP_MD_CTX\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Initialize the DigestSign operation */
    if (EVP_DigestSignInit(md_ctx, NULL, md, NULL, pkey) != 1) {
        fprintf(stderr, "Failed to initialize DigestSign operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Process the message */
    if (EVP_DigestSignUpdate(md_ctx, message, message_len) != 1) {
        fprintf(stderr, "Failed to update DigestSign operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Get signature length */
    if (EVP_DigestSignFinal(md_ctx, NULL, signature_len) != 1) {
        fprintf(stderr, "Failed to determine signature length\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Allocate memory for signature */
    *signature = OPENSSL_malloc(*signature_len);
    if (!(*signature)) {
        fprintf(stderr, "Failed to allocate memory for signature\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Generate signature */
    if (EVP_DigestSignFinal(md_ctx, *signature, signature_len) != 1) {
        fprintf(stderr, "Failed to create signature\n");
        print_openssl_errors();
        OPENSSL_free(*signature);
        *signature = NULL;
        goto cleanup;
    }
    
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/* Verify a signature using EVP_DigestVerify API */
int verify_using_evp_digestverify(const unsigned char *message, size_t message_len,
                                const unsigned char *signature, size_t signature_len,
                                EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_MD_CTX *md_ctx = NULL;
    int ret = 0;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create EVP_MD_CTX\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Initialize the DigestVerify operation */
    if (EVP_DigestVerifyInit(md_ctx, NULL, md, NULL, pkey) != 1) {
        fprintf(stderr, "Failed to initialize DigestVerify operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Process the message */
    if (EVP_DigestVerifyUpdate(md_ctx, message, message_len) != 1) {
        fprintf(stderr, "Failed to update DigestVerify operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Verify signature */
    if (EVP_DigestVerifyFinal(md_ctx, signature, signature_len) != 1) {
        fprintf(stderr, "Signature verification failed\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/*
 * Pair 3: Using EVP_PKEY_sign API (lower level API with direct control)
 * This API offers direct control over the signing operation
 */

/* Sign a message using EVP_PKEY_sign API - requires pre-hashed message */
int sign_using_evp_pkey_sign(const unsigned char *digest, size_t digest_len,
                           unsigned char **signature, size_t *signature_len,
                           EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_PKEY_CTX *pkey_ctx = NULL;
    int ret = 0;
    
    /* Create the context for the signing operation */
    if (!(pkey_ctx = EVP_PKEY_CTX_new(pkey, NULL))) {
        fprintf(stderr, "Failed to create PKEY context\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Initialize signing operation */
    if (EVP_PKEY_sign_init(pkey_ctx) != 1) {
        fprintf(stderr, "Failed to initialize signing operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Set the message digest to use */
    if (EVP_PKEY_CTX_set_signature_md(pkey_ctx, md) != 1) {
        fprintf(stderr, "Failed to set signature message digest\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Get signature length */
    if (EVP_PKEY_sign(pkey_ctx, NULL, signature_len, digest, digest_len) != 1) {
        fprintf(stderr, "Failed to determine signature length\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Allocate memory for signature */
    *signature = OPENSSL_malloc(*signature_len);
    if (!(*signature)) {
        fprintf(stderr, "Failed to allocate memory for signature\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Generate signature */
    if (EVP_PKEY_sign(pkey_ctx, *signature, signature_len, digest, digest_len) != 1) {
        fprintf(stderr, "Failed to create signature\n");
        print_openssl_errors();
        OPENSSL_free(*signature);
        *signature = NULL;
        goto cleanup;
    }
    
    ret = 1;
    
cleanup:
    EVP_PKEY_CTX_free(pkey_ctx);
    return ret;
}

/* Verify a signature using EVP_PKEY_verify API - requires pre-hashed message */
int verify_using_evp_pkey_verify(const unsigned char *digest, size_t digest_len,
                               const unsigned char *signature, size_t signature_len,
                               EVP_PKEY *pkey, const EVP_MD *md) {
    EVP_PKEY_CTX *pkey_ctx = NULL;
    int ret = 0;
    
    /* Create the context for verification operation */
    if (!(pkey_ctx = EVP_PKEY_CTX_new(pkey, NULL))) {
        fprintf(stderr, "Failed to create PKEY context\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Initialize verification operation */
    if (EVP_PKEY_verify_init(pkey_ctx) != 1) {
        fprintf(stderr, "Failed to initialize verification operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Set the message digest */
    if (EVP_PKEY_CTX_set_signature_md(pkey_ctx, md) != 1) {
        fprintf(stderr, "Failed to set signature message digest\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Verify signature */
    if (EVP_PKEY_verify(pkey_ctx, signature, signature_len, digest, digest_len) != 1) {
        fprintf(stderr, "Signature verification failed\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    ret = 1;
    
cleanup:
    EVP_PKEY_CTX_free(pkey_ctx);
    return ret;
}

/*
 * Pair 4: Using EVP_MD_CTX with EVP_PKEY_CTX (fine-grained control)
 * This allows for customization of the signing parameters
 */

/* Sign a message using EVP_DigestSignInit with explicit EVP_PKEY_CTX */
int sign_using_digestsign_with_ctx(const unsigned char *message, size_t message_len,
                                 unsigned char **signature, size_t *signature_len,
                                 EVP_PKEY *pkey, const EVP_MD *md, 
                                 int (*param_setter)(EVP_PKEY_CTX *ctx)) {
    EVP_MD_CTX *md_ctx = NULL;
    EVP_PKEY_CTX *pkey_ctx = NULL;
    int ret = 0;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create digest context\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Initialize the DigestSign operation with explicit PKEY_CTX */
    if (EVP_DigestSignInit(md_ctx, &pkey_ctx, md, NULL, pkey) != 1) {
        fprintf(stderr, "Failed to initialize DigestSign operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Apply custom parameters if provided */
    if (param_setter && param_setter(pkey_ctx) != 1) {
        fprintf(stderr, "Failed to set custom parameters\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Process the message */
    if (EVP_DigestSignUpdate(md_ctx, message, message_len) != 1) {
        fprintf(stderr, "Failed to update DigestSign operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Get signature length */
    if (EVP_DigestSignFinal(md_ctx, NULL, signature_len) != 1) {
        fprintf(stderr, "Failed to determine signature length\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Allocate memory for signature */
    *signature = OPENSSL_malloc(*signature_len);
    if (!(*signature)) {
        fprintf(stderr, "Failed to allocate memory for signature\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Generate signature */
    if (EVP_DigestSignFinal(md_ctx, *signature, signature_len) != 1) {
        fprintf(stderr, "Failed to create signature\n");
        print_openssl_errors();
        OPENSSL_free(*signature);
        *signature = NULL;
        goto cleanup;
    }
    
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/* Verify a signature using EVP_DigestVerifyInit with explicit EVP_PKEY_CTX */
int verify_using_digestverify_with_ctx(const unsigned char *message, size_t message_len,
                                     const unsigned char *signature, size_t signature_len,
                                     EVP_PKEY *pkey, const EVP_MD *md,
                                     int (*param_setter)(EVP_PKEY_CTX *ctx)) {
    EVP_MD_CTX *md_ctx = NULL;
    EVP_PKEY_CTX *pkey_ctx = NULL;
    int ret = 0;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create digest context\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Initialize the DigestVerify operation with explicit PKEY_CTX */
    if (EVP_DigestVerifyInit(md_ctx, &pkey_ctx, md, NULL, pkey) != 1) {
        fprintf(stderr, "Failed to initialize DigestVerify operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Apply custom parameters if provided */
    if (param_setter && param_setter(pkey_ctx) != 1) {
        fprintf(stderr, "Failed to set custom parameters\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Process the message */
    if (EVP_DigestVerifyUpdate(md_ctx, message, message_len) != 1) {
        fprintf(stderr, "Failed to update DigestVerify operation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Verify signature */
    if (EVP_DigestVerifyFinal(md_ctx, signature, signature_len) != 1) {
        fprintf(stderr, "Signature verification failed\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/*
 * Pair 5: Using the old low-level APIs (for compatibility with legacy code)
 * These APIs are deprecated but may still be found in older codebases
 */

/* Sign using RSA_sign (low-level API, only for RSA) */
int sign_using_rsa_sign(const unsigned char *message, size_t message_len,
                       unsigned char **signature, size_t *signature_len,
                       RSA *rsa_key, int hash_nid, const EVP_MD *md) {
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    int ret = 0;
    EVP_MD_CTX *md_ctx = NULL;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create EVP_MD_CTX\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Calculate hash of the message */
    if (EVP_DigestInit_ex(md_ctx, md, NULL) != 1) {
        fprintf(stderr, "Failed to initialize digest\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    if (EVP_DigestUpdate(md_ctx, message, message_len) != 1) {
        fprintf(stderr, "Failed to update digest\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    if (EVP_DigestFinal_ex(md_ctx, digest, &digest_len) != 1) {
        fprintf(stderr, "Failed to finalize digest\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Allocate memory for signature */
    *signature_len = RSA_size(rsa_key);
    *signature = OPENSSL_malloc(*signature_len);
    if (!(*signature)) {
        fprintf(stderr, "Failed to allocate memory for signature\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Sign with RSA_sign */
    if (RSA_sign(hash_nid, digest, digest_len, *signature, 
                 (unsigned int*)signature_len, rsa_key) != 1) {
        fprintf(stderr, "Failed to create RSA signature\n");
        print_openssl_errors();
        OPENSSL_free(*signature);
        *signature = NULL;
        goto cleanup;
    }
    
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/* Verify using RSA_verify (low-level API, only for RSA) */
int verify_using_rsa_verify(const unsigned char *message, size_t message_len,
                          const unsigned char *signature, size_t signature_len,
                          RSA *rsa_key, int hash_nid, const EVP_MD *md) {
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    int ret = 0;
    EVP_MD_CTX *md_ctx = NULL;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create EVP_MD_CTX\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Calculate hash of the message */
    if (EVP_DigestInit_ex(md_ctx, md, NULL) != 1) {
        fprintf(stderr, "Failed to initialize digest\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    if (EVP_DigestUpdate(md_ctx, message, message_len) != 1) {
        fprintf(stderr, "Failed to update digest\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    if (EVP_DigestFinal_ex(md_ctx, digest, &digest_len) != 1) {
        fprintf(stderr, "Failed to finalize digest\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Verify signature with RSA_verify */
    if (RSA_verify(hash_nid, digest, digest_len, signature, 
                  (unsigned int)signature_len, rsa_key) != 1) {
        fprintf(stderr, "RSA signature verification failed\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    ret = 1;
    
cleanup:
    EVP_MD_CTX_free(md_ctx);
    return ret;
}

/* 
 * Helper function example for getting an RSA key from an EVP_PKEY
 * (would be needed for the low-level RSA API functions) 
 */
RSA *get_rsa_from_pkey(EVP_PKEY *pkey) {
    RSA *rsa = EVP_PKEY_get1_RSA(pkey);
    if (!rsa) {
        fprintf(stderr, "Failed to get RSA key from EVP_PKEY\n");
        print_openssl_errors();
    }
    return rsa;
}

/* Helper function for setting RSA padding mode to PSS */
int set_rsa_pss_padding(EVP_PKEY_CTX *ctx) {
    /* Set padding mode to PSS */
    if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_PSS_PADDING) != 1) {
        fprintf(stderr, "Failed to set RSA padding to PSS\n");
        print_openssl_errors();
        return 0;
    }
    
    return 1;
}

/* Generic test function demonstrating APIs 1-4 with any algorithm */
int test_signature_apis(EVP_PKEY *key, const EVP_MD *md, 
                        int (*param_setter)(EVP_PKEY_CTX *ctx),
                        const char *algo_name) {
    unsigned char *signature1 = NULL, *signature2 = NULL, 
                  *signature3 = NULL, *signature4 = NULL;
    size_t sig_len1 = 0, sig_len2 = 0, sig_len3 = 0, sig_len4 = 0;
    int result = 0;
    
    /* Message to sign */
    const unsigned char message[] = "Test message for OpenSSL signature APIs";
    const size_t message_len = strlen((char *)message);
    
    printf("\nTesting signature APIs with %s:\n", algo_name);
    
    /* Test Pair 1: EVP_Sign API */
    printf("1. Testing EVP_Sign API (older API):\n");
    if (sign_using_evp_sign(message, message_len, &signature1, &sig_len1, key, md)) {
        printf("   Signature created successfully (length: %zu bytes)\n", sig_len1);
        
        /* Verify the signature */
        if (verify_using_evp_verify(message, message_len, signature1, sig_len1, key, md)) {
            printf("   Signature verified successfully\n");
        } else {
            printf("   Signature verification failed\n");
            goto cleanup;
        }
    } else {
        printf("   Failed to create signature\n");
        goto cleanup;
    }
    
    /* Test Pair 2: EVP_DigestSign API */
    printf("\n2. Testing EVP_DigestSign API (recommended modern API):\n");
    if (sign_using_evp_digestsign(message, message_len, &signature2, &sig_len2, key, md)) {
        printf("   Signature created successfully (length: %zu bytes)\n", sig_len2);
        
        /* Verify the signature */
        if (verify_using_evp_digestverify(message, message_len, signature2, sig_len2, key, md)) {
            printf("   Signature verified successfully\n");
        } else {
            printf("   Signature verification failed\n");
            goto cleanup;
        }
    } else {
        printf("   Failed to create signature\n");
        goto cleanup;
    }
    
    /* Test Pair 3: EVP_PKEY_sign API */
    printf("\n3. Testing EVP_PKEY_sign API (lower level API):\n");
    /* First create a digest of the message */
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    EVP_MD_CTX *md_ctx = EVP_MD_CTX_new();
    if (!md_ctx) {
        fprintf(stderr, "Failed to create digest context\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    if (EVP_DigestInit_ex(md_ctx, md, NULL) != 1 ||
        EVP_DigestUpdate(md_ctx, message, message_len) != 1 ||
        EVP_DigestFinal_ex(md_ctx, digest, &digest_len) != 1) {
        fprintf(stderr, "Failed to create message digest\n");
        print_openssl_errors();
        EVP_MD_CTX_free(md_ctx);
        goto cleanup;
    }
    EVP_MD_CTX_free(md_ctx);
    
    if (sign_using_evp_pkey_sign(digest, digest_len, &signature3, &sig_len3, key, md)) {
        printf("   Signature created successfully (length: %zu bytes)\n", sig_len3);
        
        /* Verify the signature */
        if (verify_using_evp_pkey_verify(digest, digest_len, signature3, sig_len3, key, md)) {
            printf("   Signature verified successfully\n");
        } else {
            printf("   Signature verification failed\n");
            goto cleanup;
        }
    } else {
        printf("   Failed to create signature\n");
        goto cleanup;
    }
    
    /* Test Pair 4: EVP_DigestSign with explicit PKEY_CTX */
    printf("\n4. Testing EVP_DigestSign with explicit PKEY_CTX (fine-grained control):\n");
    if (sign_using_digestsign_with_ctx(message, message_len, &signature4, &sig_len4, 
                                      key, md, param_setter)) {
        printf("   Signature created successfully (length: %zu bytes)\n", sig_len4);
        
        /* Verify the signature */
        if (verify_using_digestverify_with_ctx(message, message_len, signature4, sig_len4, 
                                               key, md, param_setter)) {
            printf("   Signature verified successfully\n");
        } else {
            printf("   Signature verification failed\n");
            goto cleanup;
        }
    } else {
        printf("   Failed to create signature\n");
        goto cleanup;
    }
    
    result = 1;
    
cleanup:
    /* Free allocated resources */
    OPENSSL_free(signature1);
    OPENSSL_free(signature2);
    OPENSSL_free(signature3);
    OPENSSL_free(signature4);
    
    return result;
}

/* RSA-specific test function that uses both the generic API tests and the RSA-specific pair 5 */
int test_signature_apis_rsa(void) {
    EVP_PKEY *key = NULL;
    EVP_PKEY_CTX *key_ctx = NULL;
    const EVP_MD *md = NULL;
    unsigned char *signature5 = NULL;
    size_t sig_len5 = 0;
    int result = 0;
    RSA *rsa_key = NULL;
    
    /* Message to sign */
    const unsigned char message[] = "Test message for OpenSSL signature APIs";
    const size_t message_len = strlen((char *)message);
    
    /* Create a message digest */
    md = EVP_sha256();
    if (!md) {
        fprintf(stderr, "Failed to get SHA256 digest\n");
        goto cleanup;
    }
    
    /* Create an RSA key for testing */
    printf("Generating RSA key pair for testing...\n");
    key_ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_RSA, NULL);
    if (!key_ctx) {
        fprintf(stderr, "Failed to create key generation context\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    if (EVP_PKEY_keygen_init(key_ctx) <= 0) {
        fprintf(stderr, "Failed to initialize key generation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Use smaller key size for quicker test */
    if (EVP_PKEY_CTX_set_rsa_keygen_bits(key_ctx, 2048) <= 0) {
        fprintf(stderr, "Failed to set key size\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    if (EVP_PKEY_keygen(key_ctx, &key) <= 0) {
        fprintf(stderr, "Failed to generate key\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Extract RSA key for low-level functions */
    rsa_key = get_rsa_from_pkey(key);
    if (!rsa_key) {
        goto cleanup;
    }
    
    /* Run the generic tests for APIs 1-4 */
    if (!test_signature_apis(key, md, set_rsa_pss_padding, "RSA")) {
        fprintf(stderr, "Generic signature API tests failed\n");
        goto cleanup;
    }
    
    /* Test Pair 5: Low-level RSA API (RSA-specific) */
    printf("\n5. Testing low-level RSA API (deprecated but still found in legacy code):\n");
    if (sign_using_rsa_sign(message, message_len, &signature5, &sig_len5, 
                           rsa_key, NID_sha256, md)) {
        printf("   Signature created successfully (length: %zu bytes)\n", sig_len5);
        
        /* Verify the signature */
        if (verify_using_rsa_verify(message, message_len, signature5, sig_len5, 
                                   rsa_key, NID_sha256, md)) {
            printf("   Signature verified successfully\n");
        } else {
            printf("   Signature verification failed\n");
            goto cleanup;
        }
    } else {
        printf("   Failed to create signature\n");
        goto cleanup;
    }
    
    printf("\nSummary of OpenSSL signature APIs with RSA:\n");
    printf("1. EVP_Sign API: Older, simpler API with fewer options\n");
    printf("2. EVP_DigestSign API: Modern recommended API with better algorithm support\n");
    printf("3. EVP_PKEY_sign API: Lower-level API requiring pre-hashed message\n");
    printf("4. EVP_DigestSign with explicit PKEY_CTX: For fine-grained parameter control\n");
    printf("5. Low-level RSA API: Deprecated but may be found in legacy code\n");
    
    result = 1;
    
cleanup:
    /* Free allocated resources */
    OPENSSL_free(signature5);
    RSA_free(rsa_key); /* RSA_free decrements reference count */
    EVP_PKEY_free(key);
    EVP_PKEY_CTX_free(key_ctx);
    
    if (!result) {
        fprintf(stderr, "Test failed with errors\n");
        print_openssl_errors();
    }
    
    return result;
}

/* No special parameter setter needed for default DSA behavior */
int no_parameter_setter(EVP_PKEY_CTX *ctx) {
    /* No changes needed for default DSA parameters */
    return 1;
}

/* Helper function to get DSA key from EVP_PKEY for low-level operations */
DSA *get_dsa_from_pkey(EVP_PKEY *pkey) {
    DSA *dsa = EVP_PKEY_get1_DSA(pkey);
    if (!dsa) {
        fprintf(stderr, "Failed to get DSA key from EVP_PKEY\n");
        print_openssl_errors();
    }
    return dsa;
}

/* Sign a message using low-level DSA functions */
int sign_using_dsa_sign(const unsigned char *message, size_t message_len,
                      unsigned char **signature, size_t *signature_len,
                      DSA *dsa_key, const EVP_MD *md) {
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    int ret = 0;
    EVP_MD_CTX *md_ctx = NULL;
    DSA_SIG *sig = NULL;
    const BIGNUM *r = NULL, *s = NULL;
    unsigned int r_len, s_len, bn_len;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create EVP_MD_CTX\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Calculate hash of the message */
    if (EVP_DigestInit_ex(md_ctx, md, NULL) != 1 ||
        EVP_DigestUpdate(md_ctx, message, message_len) != 1 ||
        EVP_DigestFinal_ex(md_ctx, digest, &digest_len) != 1) {
        fprintf(stderr, "Failed to create message digest\n");
        print_openssl_errors();
        EVP_MD_CTX_free(md_ctx);
        return 0;
    }
    EVP_MD_CTX_free(md_ctx);
    
    /* Sign digest with DSA_do_sign */
    sig = DSA_do_sign(digest, digest_len, dsa_key);
    if (sig == NULL) {
        fprintf(stderr, "Failed to create DSA signature\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Extract r and s components from signature */
    DSA_SIG_get0(sig, &r, &s);
    if (r == NULL || s == NULL) {
        fprintf(stderr, "Failed to extract r and s from DSA_SIG\n");
        DSA_SIG_free(sig);
        return 0;
    }
    
    /* Determine the size of r and s */
    bn_len = DSA_size(dsa_key) / 2;
    r_len = BN_num_bytes(r);
    s_len = BN_num_bytes(s);
    
    /* Allocate memory for DER encoded signature */
    *signature_len = DSA_size(dsa_key);
    *signature = OPENSSL_malloc(*signature_len);
    if (!(*signature)) {
        fprintf(stderr, "Failed to allocate memory for signature\n");
        print_openssl_errors();
        DSA_SIG_free(sig);
        return 0;
    }
    
    /* Create the signature buffer with r and s values */
    memset(*signature, 0, *signature_len);
    
    /* Copy r to the first half of the signature */
    if (BN_bn2bin(r, *signature + (bn_len - r_len)) <= 0) {
        fprintf(stderr, "Failed to convert r to binary\n");
        print_openssl_errors();
        OPENSSL_free(*signature);
        *signature = NULL;
        DSA_SIG_free(sig);
        return 0;
    }
    
    /* Copy s to the second half of the signature */
    if (BN_bn2bin(s, *signature + bn_len + (bn_len - s_len)) <= 0) {
        fprintf(stderr, "Failed to convert s to binary\n");
        print_openssl_errors();
        OPENSSL_free(*signature);
        *signature = NULL;
        DSA_SIG_free(sig);
        return 0;
    }
    
    DSA_SIG_free(sig);
    ret = 1;
    
    return ret;
}

/* Verify a signature using low-level DSA functions */
int verify_using_dsa_verify(const unsigned char *message, size_t message_len,
                          const unsigned char *signature, size_t signature_len,
                          DSA *dsa_key, const EVP_MD *md) {
    unsigned char digest[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    int ret = 0;
    EVP_MD_CTX *md_ctx = NULL;
    DSA_SIG *sig = NULL;
    BIGNUM *r = NULL, *s = NULL;
    unsigned int bn_len;
    
    /* Create digest context */
    if (!(md_ctx = EVP_MD_CTX_new())) {
        fprintf(stderr, "Failed to create EVP_MD_CTX\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Calculate hash of the message */
    if (EVP_DigestInit_ex(md_ctx, md, NULL) != 1 ||
        EVP_DigestUpdate(md_ctx, message, message_len) != 1 ||
        EVP_DigestFinal_ex(md_ctx, digest, &digest_len) != 1) {
        fprintf(stderr, "Failed to create message digest\n");
        print_openssl_errors();
        EVP_MD_CTX_free(md_ctx);
        return 0;
    }
    EVP_MD_CTX_free(md_ctx);
    
    /* Create a new DSA_SIG structure */
    sig = DSA_SIG_new();
    if (sig == NULL) {
        fprintf(stderr, "Failed to create DSA_SIG structure\n");
        print_openssl_errors();
        return 0;
    }
    
    /* Set up r and s BIGNUMs */
    r = BN_new();
    s = BN_new();
    if (r == NULL || s == NULL) {
        fprintf(stderr, "Failed to create BIGNUM for r or s\n");
        print_openssl_errors();
        DSA_SIG_free(sig);
        BN_free(r);
        BN_free(s);
        return 0;
    }
    
    /* Determine the size of each component */
    bn_len = DSA_size(dsa_key) / 2;
    
    /* Convert binary signature to r and s components */
    if (BN_bin2bn(signature, bn_len, r) == NULL ||
        BN_bin2bn(signature + bn_len, bn_len, s) == NULL) {
        fprintf(stderr, "Failed to convert binary signature to r and s\n");
        print_openssl_errors();
        DSA_SIG_free(sig);
        BN_free(r);
        BN_free(s);
        return 0;
    }
    
    /* Set r and s in the DSA_SIG structure */
    if (DSA_SIG_set0(sig, r, s) != 1) {
        fprintf(stderr, "Failed to set r and s in DSA_SIG\n");
        print_openssl_errors();
        DSA_SIG_free(sig);
        BN_free(r);
        BN_free(s);
        return 0;
    }
    
    /* r and s are now owned by sig, don't free them separately */
    
    /* Verify the signature */
    ret = DSA_do_verify(digest, digest_len, sig, dsa_key);
    if (ret != 1) {
        fprintf(stderr, "DSA signature verification failed\n");
        print_openssl_errors();
    }
    
    DSA_SIG_free(sig);
    return (ret == 1);
}

/* Test function for DSA signatures */
int test_signature_apis_dsa(void) {
    EVP_PKEY *key = NULL;
    EVP_PKEY_CTX *key_ctx = NULL;
    EVP_PKEY_CTX *param_ctx = NULL;
    const EVP_MD *md = NULL;
    unsigned char *signature5 = NULL;
    size_t sig_len5 = 0;
    int result = 0;
    DSA *dsa_key = NULL;
    EVP_PKEY *params = NULL;
    
    /* Message to sign */
    const unsigned char message[] = "Test message for OpenSSL signature APIs";
    const size_t message_len = strlen((char *)message);
    
    /* Create a message digest */
    md = EVP_sha256();
    if (!md) {
        fprintf(stderr, "Failed to get SHA256 digest\n");
        goto cleanup;
    }
    
    /* Create a DSA key for testing */
    printf("Generating DSA key pair for testing...\n");
    
    /* Step 1: Create parameter generation context using the "DSA" algorithm name */
    param_ctx = EVP_PKEY_CTX_new_from_name(NULL, "DSA", NULL);
    if (!param_ctx) {
        fprintf(stderr, "Failed to create DSA parameter generation context\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Step 2: Initialize the parameter generation context */
    if (EVP_PKEY_paramgen_init(param_ctx) <= 0) {
        fprintf(stderr, "Failed to initialize parameter generation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Step 3: Set parameter size */
    if (EVP_PKEY_CTX_set_dsa_paramgen_bits(param_ctx, 2048) <= 0) {
        fprintf(stderr, "Failed to set DSA parameter size\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Step 4: Generate the parameters */
    printf("Generating DSA parameters (this may take a moment)...\n");
    if (EVP_PKEY_paramgen(param_ctx, &params) <= 0) {
        fprintf(stderr, "Failed to generate DSA parameters\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Step 5: Create key generation context using the parameters */
    key_ctx = EVP_PKEY_CTX_new(params, NULL);
    if (!key_ctx) {
        fprintf(stderr, "Failed to create key generation context\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Step 6: Initialize for key generation */
    if (EVP_PKEY_keygen_init(key_ctx) <= 0) {
        fprintf(stderr, "Failed to initialize key generation\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    /* Step 7: Generate the key pair */
    printf("Generating DSA key pair using parameters...\n");
    if (EVP_PKEY_keygen(key_ctx, &key) <= 0) {
        fprintf(stderr, "Failed to generate DSA key\n");
        print_openssl_errors();
        goto cleanup;
    }
    
    printf("DSA key generation completed successfully\n");
    
    /* Extract DSA key for low-level functions */
    dsa_key = get_dsa_from_pkey(key);
    if (!dsa_key) {
        goto cleanup;
    }
    
    /* Run the generic tests for APIs 1-4 */
    printf("\nRunning generic signature tests (APIs 1-4) with DSA\n");
    if (!test_signature_apis(key, md, no_parameter_setter, "DSA")) {
        fprintf(stderr, "Generic signature API tests failed with DSA\n");
        goto cleanup;
    }
    
    /* Test Pair 5: Low-level DSA API */
    printf("\n5. Testing low-level DSA API (deprecated but still found in legacy code):\n");
    if (sign_using_dsa_sign(message, message_len, &signature5, &sig_len5, dsa_key, md)) {
        printf("   Signature created successfully (length: %zu bytes)\n", sig_len5);
        
        /* Verify the signature */
        if (verify_using_dsa_verify(message, message_len, signature5, sig_len5, dsa_key, md)) {
            printf("   Signature verified successfully\n");
        } else {
            printf("   Signature verification failed\n");
            goto cleanup;
        }
    } else {
        printf("   Failed to create signature\n");
        goto cleanup;
    }
    
    printf("\nSummary of OpenSSL signature APIs with DSA:\n");
    printf("1. EVP_Sign API: Older, simpler API with fewer options\n");
    printf("2. EVP_DigestSign API: Modern recommended API with better algorithm support\n");
    printf("3. EVP_PKEY_sign API: Lower-level API requiring pre-hashed message\n");
    printf("4. EVP_DigestSign with explicit PKEY_CTX: For fine-grained parameter control\n");
    printf("5. Low-level DSA API: Deprecated but may be found in legacy code\n");
    
    result = 1;
    
cleanup:
    /* Free allocated resources */
    OPENSSL_free(signature5);
    /* dsa_key is owned by the EVP_PKEY, don't free it separately */
    EVP_PKEY_free(params);
    EVP_PKEY_free(key);
    EVP_PKEY_CTX_free(param_ctx);
    EVP_PKEY_CTX_free(key_ctx);
    
    if (!result) {
        fprintf(stderr, "DSA signature test failed with errors\n");
        print_openssl_errors();
    }
    
    return result;
}

/* Main function to run the test suite */
int main(void) {
    /* Initialize OpenSSL */
    OpenSSL_add_all_algorithms();
    ERR_load_crypto_strings();
    
    int result = 0;
    
    printf("\n-------- TESTING RSA SIGNATURES --------\n");
    result = test_signature_apis_rsa();
    
    printf("\n-------- TESTING DSA SIGNATURES --------\n");
    result &= test_signature_apis_dsa();
    
    if (result) {
        printf("\nAll tests completed successfully.\n");
        return 0;
    } else {
        fprintf(stderr, "\nSome tests failed.\n");
        return 1;
    }
}
