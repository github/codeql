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
  * Returns a string to represent generally unknown algorithms. 
  * Predicate is to be used to get a consistent string representation 
  * for unknown algorithms.
  */
 string unknownAlgorithm()
 {
  result = "UNKNOWN"
 }


 /**
  * Holds if `name` is a known hashing algorithm in the model/library.
  */
 predicate isKnownHashingAlgorithm(string name)
 {
  isStrongHashingAlgorithm(name) or isWeakHashingAlgorithm(name)
 }

/**
 * Holds if `name` corresponds to a strong hashing algorithm.
 */
predicate isStrongHashingAlgorithm(string name) {
  name =
    [
      "BLAKE2", "BLAKE2b", "BLAKE2s", "DSA", "ED25519", "ES256", "ECDSA256", "ES384", "ECDSA384", "ES512", "ECDSA512", "SHA2",
      "SHA224", "SHA256", "SHA384", "SHA512", "SHA3", "SHA3224", "SHA3256", "SHA3384", "SHA3512", 
      "SHAKE128", "SHAKE256"
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
  * Holds if `name` is a known encryption algorithm in the model/library.
  */
 predicate isKnownEncryptionAlgorithm(string name)
 {
  isStrongEncryptionAlgorithm(name) or isWeakEncryptionAlgorithm(name)
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
      "IDEA", "RABBIT", "RSA", "SEED", "SM3", "SM4"
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
  * Holds if `name` is a known password hashing algorithm in the model/library.
  */
 predicate isKnownPasswordHashingAlgorithm(string name)
 {
  isStrongPasswordHashingAlgorithm(name) or isWeakPasswordHashingAlgorithm(name)
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
predicate isWeakPasswordHashingAlgorithm(string name) { 
  name = "EVPKDF" 
}

 /**
  * Holds if `name` is a known cipher block mode algorithm in the model/library.
  */
 predicate isKnownCipherBlockModeAlgorithm(string name)
 {
  isStrongCipherBlockModeAlgorithm(name) or isWeakCipherBlockModeAlgorithm(name)
 }


/**
 * Holds if `name` corresponds to a strong cipher block mode
 */
predicate isStrongCipherBlockModeAlgorithm(string name)
{
  name = ["CBC", "GCM", "CCM", "CFB", "OFB", "CFB8", "CTR", "OPENPGP", "XTS"]
}

/**
 * Holds if `name` corresponds to a weak cipher block mode
 */
predicate isWeakCipherBlockModeAlgorithm(string name)
{
  name = ["ECB"]
}


/**
 * Holds if `name` corresponds to a stream cipher.
 */
predicate isStreamCipher(string name) { name = ["CHACHA", "RC4", "ARC4", "ARCFOUR", "RABBIT"] }
