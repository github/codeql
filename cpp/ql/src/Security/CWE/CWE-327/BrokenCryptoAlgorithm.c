void advapi() {
  HCRYPTPROV hCryptProv;
  HCRYPTKEY hKey;
  HCRYPTHASH hHash;
  // other preparation goes here

  // BAD: use 3DES for key
  CryptDeriveKey(hCryptProv, CALG_3DES, hHash, 0, &hKey);

  // GOOD: use AES
  CryptDeriveKey(hCryptProv, CALG_AES_256, hHash, 0, &hKey);
}

