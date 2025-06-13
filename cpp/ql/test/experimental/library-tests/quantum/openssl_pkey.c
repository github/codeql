
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/obj_mac.h>
#include <openssl/evp.h>

// #include <openssl/evp.h>
// #include <openssl/rsa.h>
// #include <openssl/pem.h>
// #include <openssl/err.h>
// #include <stdio.h>
// #include <string.h>


int generate_rsa_pkey() {
    int key_length = 2048;
    RSA *rsa = RSA_new();
    BIGNUM *bne = BN_new();
    BN_set_word(bne, RSA_F4);

    if (!RSA_generate_key_ex(rsa, key_length, bne, NULL)) {
        return -1;
    }

    // Save private key
    FILE *priv_file = fopen("private_key.pem", "wb");
    PEM_write_RSAPrivateKey(priv_file, rsa, NULL, NULL, 0, NULL, NULL);
    fclose(priv_file);

    // Save public key
    FILE *pub_file = fopen("public_key.pem", "wb");
    PEM_write_RSA_PUBKEY(pub_file, rsa);
    fclose(pub_file);

    RSA_free(rsa);
    BN_free(bne);

    return 0;
}


int generate_evp_pkey() {
    EVP_PKEY_CTX *ctx;
    EVP_PKEY *pkey = NULL;
    unsigned char *plaintext = (unsigned char *)"Hello, OpenSSL!";
    unsigned char encrypted[256];
    size_t encrypted_len;

    // Generate RSA key
    ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_RSA, NULL);
    if (!ctx) return -1;

    if (EVP_PKEY_keygen_init(ctx) <= 0) return -1;
    if (EVP_PKEY_CTX_set_rsa_keygen_bits(ctx, 2048) <= 0) return -1;
    if (EVP_PKEY_keygen(ctx, &pkey) <= 0) return -1;

    EVP_PKEY_CTX_free(ctx);

    // Encrypt using the generated key
    ctx = EVP_PKEY_CTX_new(pkey, NULL);
    if (!ctx) handleErrors();

    if (EVP_PKEY_encrypt_init(ctx) <= 0) return -1;
    if (EVP_PKEY_encrypt(ctx, encrypted, &encrypted_len, plaintext, strlen((char *)plaintext)) <= 0) return -1;

    EVP_PKEY_CTX_free(ctx);
    EVP_PKEY_free(pkey);

    return 0;
}
