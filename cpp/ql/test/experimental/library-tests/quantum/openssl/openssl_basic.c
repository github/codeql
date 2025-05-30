#ifdef USE_REAL_HEADERS
#include <openssl/evp.h>
#include <openssl/rsa.h>
#include <openssl/dsa.h>
#include <openssl/sha.h>
#include <openssl/err.h>
#include <stdio.h>
#include <string.h>
#else
#include "./includes/evp_stubs.h"
#include "./includes/alg_macro_stubs.h"
#include "./includes/rand_stubs.h"
#include "./includes/std_stubs.h"
#endif

// Sample OpenSSL code that demonstrates various cryptographic operations
// that can be detected by the quantum model

// Function to perform AES-256-GCM encryption
int encrypt_aes_gcm(const unsigned char *plaintext, int plaintext_len,
                   const unsigned char *key, const unsigned char *iv, int iv_len,
                   unsigned char *ciphertext, unsigned char *tag) {
    EVP_CIPHER_CTX *ctx;
    int len;
    int ciphertext_len;

    // Create and initialize the context
    if(!(ctx = EVP_CIPHER_CTX_new()))
        return -1;

    // Initialize the encryption operation
    if(1 != EVP_EncryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL))
        return -1;

    // Set IV length (for GCM mode)
    if(1 != EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, iv_len, NULL))
        return -1;

    // Initialize key and IV
    if(1 != EVP_EncryptInit_ex(ctx, NULL, NULL, key, iv))
        return -1;

    // Provide the plaintext to be encrypted
    if(1 != EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len))
        return -1;
    ciphertext_len = len;

    // Finalize the encryption
    if(1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len))
        return -1;
    ciphertext_len += len;

    // Get the tag
    if(1 != EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, 16, tag))
        return -1;

    // Clean up
    EVP_CIPHER_CTX_free(ctx);

    return ciphertext_len;
}

// Function to perform AES-256-GCM decryption
int decrypt_aes_gcm(const unsigned char *ciphertext, int ciphertext_len,
                   const unsigned char *tag, const unsigned char *key,
                   const unsigned char *iv, int iv_len, 
                   unsigned char *plaintext) {
    EVP_CIPHER_CTX *ctx;
    int len;
    int plaintext_len;
    int ret;

    // Create and initialize the context
    if(!(ctx = EVP_CIPHER_CTX_new()))
        return -1;

    // Initialize the decryption operation
    if(!EVP_DecryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL))
        return -1;

    // Set IV length
    if(!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, iv_len, NULL))
        return -1;

    // Initialize key and IV
    if(!EVP_DecryptInit_ex(ctx, NULL, NULL, key, iv))
        return -1;

    // Provide the ciphertext to be decrypted
    if(!EVP_DecryptUpdate(ctx, plaintext, &len, ciphertext, ciphertext_len))
        return -1;
    plaintext_len = len;

    // Set expected tag value
    if(!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, 16, (void*)tag))
        return -1;

    // Finalize the decryption
    ret = EVP_DecryptFinal_ex(ctx, plaintext + len, &len);

    // Clean up
    EVP_CIPHER_CTX_free(ctx);

    if(ret > 0) {
        // Success
        plaintext_len += len;
        return plaintext_len;
    } else {
        // Verification failed
        return -1;
    }
}

// Function to calculate SHA-256 hash
int calculate_sha256(const unsigned char *message, size_t message_len,
                    unsigned char *digest) {
    EVP_MD_CTX *mdctx;
    unsigned int digest_len;

    // Create and initialize the context
    if(!(mdctx = EVP_MD_CTX_new()))
        return 0;

    // Initialize the hash operation
    if(1 != EVP_DigestInit_ex(mdctx, EVP_sha256(), NULL))
        return 0;

    // Provide the message to be hashed
    if(1 != EVP_DigestUpdate(mdctx, message, message_len))
        return 0;

    // Finalize the hash
    if(1 != EVP_DigestFinal_ex(mdctx, digest, &digest_len))
        return 0;

    // Clean up
    EVP_MD_CTX_free(mdctx);

    return 1;
}

// Function to generate random bytes
int generate_random_bytes(unsigned char *buffer, size_t length) {
    return RAND_bytes(buffer, length);
}

// Function using direct EVP_Digest function (one-shot hash)
int calculate_md5_oneshot(const unsigned char *message, size_t message_len,
                         unsigned char *digest) {
    unsigned int digest_len;
    
    // Calculate MD5 in a single call
    if(1 != EVP_Digest(message, message_len, digest, &digest_len, EVP_md5(), NULL))
        return 0;
        
    return 1;
}

// Function using HMAC
int calculate_hmac_sha256(const unsigned char *key, size_t key_len,
                         const unsigned char *message, size_t message_len,
                         unsigned char *mac) {
    EVP_MD_CTX *ctx = EVP_MD_CTX_new();
    EVP_PKEY *pkey = EVP_PKEY_new_mac_key(EVP_PKEY_HMAC, NULL, key, key_len);
    
    if (!ctx || !pkey)
        return 0;
        
    if (EVP_DigestSignInit(ctx, NULL, EVP_sha256(), NULL, pkey) != 1)
        return 0;
        
    if (EVP_DigestSignUpdate(ctx, message, message_len) != 1)
        return 0;
        
    size_t mac_len = 32; // SHA-256 output size
    if (EVP_DigestSignFinal(ctx, mac, &mac_len) != 1)
        return 0;
        
    EVP_MD_CTX_free(ctx);
    EVP_PKEY_free(pkey);
    
    return 1;
}

// Test function
int test_main() {
    // Test encryption and decryption
    unsigned char *key = (unsigned char *)"01234567890123456789012345678901"; // 32 bytes
    unsigned char *iv = (unsigned char *)"0123456789012345"; // 16 bytes
    unsigned char *plaintext = (unsigned char *)"This is a test message for encryption";
    unsigned char ciphertext[1024];
    unsigned char tag[16];
    unsigned char decrypted[1024];
    int plaintext_len = strlen((char *)plaintext);
    int ciphertext_len;
    int decrypted_len;
    
    // Test SHA-256 hash
    unsigned char hash[32];
    
    // Test random generation
    unsigned char random_bytes[32];
    
    // // Initialize OpenSSL
    // ERR_load_crypto_strings();
    
    // Encrypt data
    ciphertext_len = encrypt_aes_gcm(plaintext, plaintext_len, key, iv, 16, ciphertext, tag);
    
    // Decrypt data
    decrypted_len = decrypt_aes_gcm(ciphertext, ciphertext_len, tag, key, iv, 16, decrypted);

    //printf("decrypted: %s\n", decrypted);
    
    // Calculate hash
    calculate_sha256(plaintext, plaintext_len, hash);
    
    // Generate random bytes
    generate_random_bytes(random_bytes, 32);
    
    // Calculate one-shot MD5
    unsigned char md5_hash[16];
    calculate_md5_oneshot(plaintext, plaintext_len, md5_hash);
    
    // Calculate HMAC
    unsigned char hmac[32];
    calculate_hmac_sha256(key, 32, plaintext, plaintext_len, hmac);
    
    return 0;
} 
