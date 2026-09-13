#include <openssl/evp.h>
#include <openssl/rand.h>
#include <stdlib.h>

void encrypt(EVP_CIPHER_CTX *ctx, unsigned char *iv) {
  unsigned char key[16];

  // BAD: the key is derived from a cryptographically weak generator, so an
  // attacker may be able to predict it.
  for (int i = 0; i < 16; i++) {
    key[i] = (unsigned char)rand();
  }
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, key, iv);

  // GOOD: the key is filled from a cryptographically secure generator.
  RAND_bytes(key, 16);
  EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), 0, key, iv);
}
