/**
 * Provides classes for modeling cryptographic libraries.
 */

/*
 * The following information is copied from `/semmlecode-javascript-queries/semmle/javascript/frameworks/CryptoLibraries.qll`
 * which should be considered the definitive version (as of Feb 2018)
 */

/**
 * Names of cryptographic algorithms, separated into strong and weak variants.
 *
 * The names are normalized: upper-case, no spaces, dashes or underscores.
 *
 * The names are inspired by the names used in real world crypto libraries.
 */
private module AlgorithmNames {
  predicate isStrongHashingAlgorithm(string name) {
    name = "DSA" or
    name = "ED25519" or
    name = "ES256" or
    name = "ECDSA256" or
    name = "ES384" or
    name = "ECDSA384" or
    name = "ES512" or
    name = "ECDSA512" or
    name = "SHA2" or
    name = "SHA224" or
    name = "SHA256" or
    name = "SHA384" or
    name = "SHA512" or
    name = "SHA3"
  }

  predicate isWeakHashingAlgorithm(string name) {
    name = "HAVEL128" or
    name = "MD2" or
    name = "MD4" or
    name = "MD5" or
    name = "PANAMA" or
    name = "RIPEMD" or
    name = "RIPEMD128" or
    name = "RIPEMD256" or
    name = "RIPEMD160" or
    name = "RIPEMD320" or
    name = "SHA0" or
    name = "SHA1"
  }

  predicate isStrongEncryptionAlgorithm(string name) {
    name = "AES" or
    name = "AES128" or
    name = "AES192" or
    name = "AES256" or
    name = "AES512" or
    name = "RSA" or
    name = "RABBIT" or
    name = "BLOWFISH"
  }

  predicate isWeakEncryptionAlgorithm(string name) {
    name = "DES" or
    name = "3DES" or
    name = "TRIPLEDES" or
    name = "TDEA" or
    name = "TRIPLEDEA" or
    name = "ARC2" or
    name = "RC2" or
    name = "ARC4" or
    name = "RC4" or
    name = "ARCFOUR" or
    name = "ARC5" or
    name = "RC5"
  }

  predicate isStrongPasswordHashingAlgorithm(string name) {
    name = "ARGON2" or
    name = "PBKDF2" or
    name = "BCRYPT" or
    name = "SCRYPT"
  }

  predicate isWeakPasswordHashingAlgorithm(string name) { none() }

  /**
   * Normalizes `name`: upper-case, no spaces, dashes or underscores.
   *
   * All names of this module are in this normalized form.
   */
  bindingset[name]
  string normalizeName(string name) { result = name.toUpperCase().regexpReplaceAll("[-_ ]", "") }
}

private import AlgorithmNames

/**
 * A cryptographic algorithm.
 */
private newtype TCryptographicAlgorithm =
  MkHashingAlgorithm(string name, boolean isWeak) {
    isStrongHashingAlgorithm(name) and isWeak = false
    or
    isWeakHashingAlgorithm(name) and isWeak = true
  } or
  MkEncryptionAlgorithm(string name, boolean isWeak) {
    isStrongEncryptionAlgorithm(name) and isWeak = false
    or
    isWeakEncryptionAlgorithm(name) and isWeak = true
  } or
  MkPasswordHashingAlgorithm(string name, boolean isWeak) {
    isStrongPasswordHashingAlgorithm(name) and isWeak = false
    or
    isWeakPasswordHashingAlgorithm(name) and isWeak = true
  }

/**
 * A cryptographic algorithm.
 */
abstract class CryptographicAlgorithm extends TCryptographicAlgorithm {
  /** Gets a textual representation of this element. */
  string toString() { result = getName() }

  /**
   * Gets the name of the algorithm.
   */
  abstract string getName();

  /**
   * Holds if this algorithm is weak.
   */
  abstract predicate isWeak();
}

/**
 * A hashing algorithm such as `MD5` or `SHA512`.
 */
class HashingAlgorithm extends MkHashingAlgorithm, CryptographicAlgorithm {
  string name;
  boolean isWeak;

  HashingAlgorithm() { this = MkHashingAlgorithm(name, isWeak) }

  override string getName() { result = name }

  override predicate isWeak() { isWeak = true }
}

/**
 * An encryption algorithm such as `DES` or `AES512`.
 */
class EncryptionAlgorithm extends MkEncryptionAlgorithm, CryptographicAlgorithm {
  string name;
  boolean isWeak;

  EncryptionAlgorithm() { this = MkEncryptionAlgorithm(name, isWeak) }

  override string getName() { result = name }

  override predicate isWeak() { isWeak = true }
}

/**
 * A password hashing algorithm such as `PBKDF2` or `SCRYPT`.
 */
class PasswordHashingAlgorithm extends MkPasswordHashingAlgorithm, CryptographicAlgorithm {
  string name;
  boolean isWeak;

  PasswordHashingAlgorithm() { this = MkPasswordHashingAlgorithm(name, isWeak) }

  override string getName() { result = name }

  override predicate isWeak() { isWeak = true }
}
