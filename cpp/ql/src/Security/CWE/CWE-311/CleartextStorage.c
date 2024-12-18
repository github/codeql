#include <sodium.h>
#include <stdio.h>
#include <string.h>

void writeCredentialsBad(FILE *file, const char *cleartextCredentials) {
  // BAD: write password to disk in cleartext
  fputs(cleartextCredentials, file);
}

int writeCredentialsGood(FILE *file, const char *cleartextCredentials, const unsigned char *key, const unsigned char *nonce) {
  size_t credentialsLen = strlen(cleartextCredentials);
  size_t ciphertext_len = crypto_secretbox_MACBYTES + credentialsLen;
  unsigned char *ciphertext = malloc(ciphertext_len);
  if (!ciphertext) {
    logError();
    return -1;
  }

  // encrypt the password first
  if (crypto_secretbox_easy(ciphertext, (const unsigned char *)cleartextCredentials, credentialsLen, nonce, key) != 0) {
    free(ciphertext);
    logError();
    return -1;
  }

  // GOOD: write encrypted password to disk
  fwrite(ciphertext, 1, ciphertext_len, file);

  free(ciphertext);
  return 0;
}
