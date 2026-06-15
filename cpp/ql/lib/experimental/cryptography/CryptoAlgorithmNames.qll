/**
 * Names of known cryptographic algorithms.
 * The names are standardized into upper-case, no spaces, dashes or underscores.
 */

/**
 * Returns a string to represent generally unknown algorithms.
 * Predicate is to be used to get a consistent string representation
 * for unknown algorithms.
 */
string unknownAlgorithm() { result = "UNKNOWN" }

string getHashType() { result = "HASH" }

string getSymmetricEncryptionType() { result = "SYMMETRIC_ENCRYPTION" }

string getAsymmetricEncryptionType() { result = "ASYMMETRIC_ENCRYPTION" }

string getKeyDerivationType() { result = "KEY_DERIVATION" }

string getCipherBlockModeType() { result = "BLOCK_MODE" }

string getSymmetricPaddingType() { result = "SYMMETRIC_PADDING" }

string getAsymmetricPaddingType() { result = "ASYMMETRIC_PADDING" }

string getEllipticCurveType() { result = "ELLIPTIC_CURVE" }

string getSignatureType() { result = "SIGNATURE" }

string getKeyExchangeType() { result = "KEY_EXCHANGE" }

string getAsymmetricType() {
  result in [
      getAsymmetricEncryptionType(), getSignatureType(), getKeyExchangeType(),
      getEllipticCurveType()
    ]
}

predicate isKnownType(string algType) {
  algType in [
      getHashType(), getSymmetricEncryptionType(), getAsymmetricEncryptionType(),
      getKeyDerivationType(), getCipherBlockModeType(), getSymmetricPaddingType(),
      getAsymmetricPaddingType(), getEllipticCurveType(), getSignatureType(), getKeyExchangeType()
    ]
}

predicate isKnownAlgorithm(string name) { isKnownAlgorithm(name, _) }

predicate isKnownAlgorithm(string name, string algType) {
  isHashingAlgorithm(name) and algType = "HASH"
  or
  isEncryptionAlgorithm(name, algType) and
  algType in ["SYMMETRIC_ENCRYPTION", "ASYMMETRIC_ENCRYPTION"]
  or
  isKeyDerivationAlgorithm(name) and algType = "KEY_DERIVATION"
  or
  isCipherBlockModeAlgorithm(name) and algType = "BLOCK_MODE"
  or
  isPaddingAlgorithm(name, algType) and algType in ["SYMMETRIC_PADDING", "ASYMMETRIC_PADDING"]
  or
  isEllipticCurveAlgorithm(name) and algType = "ELLIPTIC_CURVE"
  or
  isSignatureAlgorithm(name) and algType = "SIGNATURE"
  or
  isKeyExchangeAlgorithm(name) and algType = "KEY_EXCHANGE"
}

/**
 * Holds if `name` is a known hashing algorithm in the model/library.
 */
predicate isHashingAlgorithm(string name) {
  name =
    [
      "BLAKE2", "BLAKE2B", "BLAKE2S", "SHA2", "SHA224", "SHA256", "SHA384", "SHA512", "SHA512224",
      "SHA512256", "SHA3", "SHA3224", "SHA3256", "SHA3384", "SHA3512", "SHAKE128", "SHAKE256",
      "SM3", "WHIRLPOOL", "POLY1305", "HAVEL128", "MD2", "MD4", "MD5", "PANAMA", "RIPEMD",
      "RIPEMD128", "RIPEMD256", "RIPEMD160", "RIPEMD320", "SHA0", "SHA1", "SHA", "MGF1", "MGF1SHA1",
      "MDC2", "SIPHASH"
    ]
}

predicate isEncryptionAlgorithm(string name, string algType) {
  isAsymmetricEncryptionAlgorithm(name) and algType = "ASYMMETRIC_ENCRYPTION"
  or
  isSymmetricEncryptionAlgorithm(name) and algType = "SYMMETRIC_ENCRYPTION"
}

predicate isEncryptionAlgorithm(string name) { isEncryptionAlgorithm(name, _) }

/**
 * Holds if `name` corresponds to a known symmetric encryption algorithm.
 */
predicate isSymmetricEncryptionAlgorithm(string name) {
  // NOTE: AES is meant to caputure all possible key lengths
  name =
    [
      "AES", "AES128", "AES192", "AES256", "ARIA", "BLOWFISH", "BF", "ECIES", "CAST", "CAST5",
      "CAMELLIA", "CAMELLIA128", "CAMELLIA192", "CAMELLIA256", "CHACHA", "CHACHA20",
      "CHACHA20POLY1305", "GOST", "GOSTR34102001", "GOSTR341094", "GOSTR341194", "GOST2814789",
      "GOSTR341194", "GOST2814789", "GOST28147", "GOSTR341094", "GOST89", "GOST94", "GOST34102012",
      "GOST34112012", "IDEA", "RABBIT", "SEED", "SM4", "DES", "DESX", "3DES", "TDES", "2DES",
      "DES3", "TRIPLEDES", "TDEA", "TRIPLEDEA", "ARC2", "RC2", "ARC4", "RC4", "ARCFOUR", "ARC5",
      "RC5", "MAGMA", "KUZNYECHIK"
    ]
}

/**
 * Holds if `name` corresponds to a known key derivation algorithm.
 */
predicate isKeyDerivationAlgorithm(string name) {
  name =
    [
      "ARGON2", "CONCATKDF", "CONCATKDFHASH", "CONCATKDFHMAC", "KBKDFCMAC", "BCRYPT", "HKDF",
      "HKDFEXPAND", "KBKDF", "KBKDFHMAC", "PBKDF1", "PBKDF2", "PBKDF2HMAC", "PKCS5", "SCRYPT",
      "X963KDF", "EVPKDF"
    ]
}

/**
 * Holds if `name` corresponds to a known cipher block mode
 */
predicate isCipherBlockModeAlgorithm(string name) {
  name = ["CBC", "GCM", "CCM", "CFB", "OFB", "CFB8", "CTR", "OPENPGP", "XTS", "EAX", "SIV", "ECB"]
}

/**
 * Holds if `name` corresponds to a known padding algorithm
 */
predicate isPaddingAlgorithm(string name, string algType) {
  isSymmetricPaddingAlgorithm(name) and algType = "SYMMETRIC_PADDING"
  or
  isAsymmetricPaddingAlgorithm(name) and algType = "ASYMMETRIC_PADDING"
}

/**
 * holds if `name` corresponds to a known symmetric padding algorithm
 */
predicate isSymmetricPaddingAlgorithm(string name) { name = ["PKCS7", "ANSIX923"] }

/**
 * Holds if `name` corresponds to a known asymmetric padding algorithm
 */
predicate isAsymmetricPaddingAlgorithm(string name) { name = ["OAEP", "PKCS1V15", "PSS", "KEM"] }

predicate isBrainpoolCurve(string curveName, int keySize) {
  // ALL BRAINPOOL CURVES
  keySize in [160, 192, 224, 256, 320, 384, 512] and
  (
    curveName = "BRAINPOOLP" + keySize.toString() + "R1"
    or
    curveName = "BRAINPOOLP" + keySize.toString() + "T1"
  )
}

predicate isSecCurve(string curveName, int keySize) {
  // ALL SEC CURVES
  keySize in [112, 113, 128, 131, 160, 163, 192, 193, 224, 233, 239, 256, 283, 384, 409, 521, 571] and
  exists(string suff | suff in ["R1", "R2", "K1"] |
    curveName = "SECT" + keySize.toString() + suff or
    curveName = "SECP" + keySize.toString() + suff
  )
}

predicate isC2Curve(string curveName, int keySize) {
  // ALL C2 CURVES
  keySize in [163, 176, 191, 208, 239, 272, 304, 359, 368, 431] and
  exists(string pre, string suff |
    pre in ["PNB", "ONB", "TNB"] and suff in ["V1", "V2", "V3", "V4", "V5", "W1", "R1"]
  |
    curveName = "C2" + pre + keySize.toString() + suff
  )
}

predicate isPrimeCurve(string curveName, int keySize) {
  // ALL PRIME CURVES
  keySize in [192, 239, 256] and
  exists(string suff | suff in ["V1", "V2", "V3"] | curveName = "PRIME" + keySize.toString() + suff)
}

predicate isEllipticCurveAlgorithm(string curveName) { isEllipticCurveAlgorithm(curveName, _) }

/**
 * Holds if `name` corresponds to a known elliptic curve.
 */
predicate isEllipticCurveAlgorithm(string curveName, int keySize) {
  isSecCurve(curveName, keySize)
  or
  isBrainpoolCurve(curveName, keySize)
  or
  isC2Curve(curveName, keySize)
  or
  isPrimeCurve(curveName, keySize)
  or
  curveName = "ES256" and keySize = 256
  or
  curveName = "CURVE25519" and keySize = 255
  or
  curveName = "X25519" and keySize = 255
  or
  curveName = "ED25519" and keySize = 255
  or
  curveName = "CURVE448" and keySize = 448 // TODO: need to check the key size
  or
  curveName = "ED448" and keySize = 448
  or
  curveName = "X448" and keySize = 448
  or
  curveName = "NUMSP256T1" and keySize = 256
  or
  curveName = "NUMSP384T1" and keySize = 384
  or
  curveName = "NUMSP512T1" and keySize = 512
  or
  curveName = "SM2" and keySize in [256, 512]
}

/**
 * Holds if `name` corresponds to a known signature algorithm.
 */
predicate isSignatureAlgorithm(string name) {
  name =
    [
      "DSA", "ECDSA", "EDDSA", "ES256", "ES256K", "ES384", "ES512", "ED25519", "ED448", "ECDSA256",
      "ECDSA384", "ECDSA512"
    ]
}

/**
 * Holds if `name` is a key exchange algorithm.
 */
predicate isKeyExchangeAlgorithm(string name) {
  name = ["ECDH", "DH", "DIFFIEHELLMAN", "X25519", "X448"]
}

/**
 * Holds if `name` corresponds to a known asymmetric encryption.
 */
predicate isAsymmetricEncryptionAlgorithm(string name) { name = ["RSA"] }
