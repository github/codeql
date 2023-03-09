/**
 * Names of cryptographic algorithms, separated into strong and weak variants.
 *
 * The names are normalized: upper-case, no spaces, dashes or underscores.
 *
 * The names are inspired by the names used in real world crypto libraries.
 *
 * The classification into strong and weak are based on Wikipedia, OWASP and Google (2021).
 */

/**
 * Holds if `name` corresponds to a strong hashing algorithm.
 */
predicate isStrongHashingAlgorithm(string name) {
  name =
    [
      // see https://cryptography.io/en/latest/hazmat/primitives/cryptographic-hashes/#blake2
      // and https://www.blake2.net/
      "BLAKE2", "BLAKE2B", "BLAKE2S",
      // see https://github.com/BLAKE3-team/BLAKE3
      "BLAKE3",
      //
      "DSA", "ED25519", "ES256", "ECDSA256", "ES384", "ECDSA384", "ES512", "ECDSA512", "SHA2",
      "SHA224", "SHA256", "SHA384", "SHA512", "SHA3", "SHA3224", "SHA3256", "SHA3384", "SHA3512",
      // see https://cryptography.io/en/latest/hazmat/primitives/cryptographic-hashes/#cryptography.hazmat.primitives.hashes.SHAKE128
      "SHAKE128", "SHAKE256",
      // see https://cryptography.io/en/latest/hazmat/primitives/cryptographic-hashes/#sm3
      "SM3",
      // see https://security.stackexchange.com/a/216297
      "WHIRLPOOL",
    ]
}

/**
 * Holds if `name` corresponds to a weak hashing algorithm.
 */
predicate isWeakHashingAlgorithm(string name) {
  name =
    [
      "HAVEL128", "MD2", "MD4", "MD5", "PANAMA", "RIPEMD", "RIPEMD128", "RIPEMD256", "RIPEMD160",
      "RIPEMD320", "SHA0", "SHA1"
    ]
}

/**
 * Holds if `name` corresponds to a strong encryption algorithm.
 */
predicate isStrongEncryptionAlgorithm(string name) {
  name =
    [
      "AES", "AES128", "AES192", "AES256", "AES512", "AES-128", "AES-192", "AES-256", "AES-512",
      "ARIA", "BLOWFISH", "BF", "ECIES", "CAST", "CAST5", "CAMELLIA", "CAMELLIA128", "CAMELLIA192",
      "CAMELLIA256", "CAMELLIA-128", "CAMELLIA-192", "CAMELLIA-256", "CHACHA", "GOST", "GOST89",
      "IDEA", "RABBIT", "RSA", "SEED", "SM4"
    ]
}

/**
 * Holds if `name` corresponds to a weak encryption algorithm.
 */
predicate isWeakEncryptionAlgorithm(string name) {
  name =
    [
      "DES", "3DES", "DES3", "TRIPLEDES", "DESX", "TDEA", "TRIPLEDEA", "ARC2", "RC2", "ARC4", "RC4",
      "ARCFOUR", "ARC5", "RC5"
    ]
}

/**
 * Holds if `name` corresponds to a strong password hashing algorithm.
 */
predicate isStrongPasswordHashingAlgorithm(string name) {
  name = ["ARGON2", "PBKDF2", "BCRYPT", "SCRYPT"]
}

/**
 * Holds if `name` corresponds to a weak password hashing algorithm.
 */
predicate isWeakPasswordHashingAlgorithm(string name) { name = "EVPKDF" }

/**
 * Holds if `name` corresponds to a stream cipher.
 */
predicate isStreamCipher(string name) { name = ["CHACHA", "RC4", "ARC4", "ARCFOUR", "RABBIT"] }
