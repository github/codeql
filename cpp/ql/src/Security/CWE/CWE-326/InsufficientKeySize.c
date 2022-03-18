void encrypt_with_openssl(EVP_PKEY_CTX *ctx) {

  // BAD: only 1024 bits for an RSA key
  EVP_PKEY_CTX_set_rsa_keygen_bits(ctx, 1024);

  // GOOD: 2048 bits for an RSA key
  EVP_PKEY_CTX_set_rsa_keygen_bits(ctx, 2048);
}