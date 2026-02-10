predicate isHashingAlgorithm(string name) {
  name =
    [
      "blake2", "blake2b", "blake2s", "sha2", "sha224", "sha256", "sha384", "sha512", "sha512224",
      "sha512256", "sha3", "sha3224", "sha3256", "sha3384", "sha3512", "shake128", "shake256",
      "sm3", "whirlpool", "poly1305", "havel128", "md2", "md4", "md5", "panama", "ripemd",
      "ripemd128", "ripemd256", "ripemd160", "ripemd320", "sha0", "sha1", "sha", "mgf1", "mgf1sha1",
      "mdc2", "siphash"
    ]
}

predicate isSymmetricAlgorithm(string name) {
  name =
    [
      "aes", "aes128", "aes192", "aes256", "aria", "blowfish", "bf", "ecies", "cast", "cast5",
      "camellia", "camellia128", "camellia192", "camellia256", "chacha", "chacha20",
      "chacha20poly1305", "gost", "gostr34102001", "gostr341094", "gostr341194", "gost2814789",
      "gostr341194", "gost2814789", "gost28147", "gostr341094", "gost89", "gost94", "gost34102012",
      "gost34112012", "idea", "rabbit", "seed", "sm4", "des", "desx", "3des", "tdes", "2des",
      "des3", "tripledes", "tdea", "tripledea", "arc2", "rc2", "arc4", "rc4", "arcfour", "arc5",
      "rc5", "magma", "kuznyechik"
    ]
}

predicate isCipherBlockModeAlgorithm(string name) {
  name = ["cbc", "gcm", "ccm", "cfb", "ofb", "cfb8", "ctr", "openpgp", "xts", "eax", "siv", "ecb"]
}

string unknownAlgorithm() { result = "UNKNOWN" }
