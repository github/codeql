/**
 * Provides classes modeling cryptographic algorithms, separated into strong and weak variants.
 *
 * The classification into strong and weak are based on Wikipedia, OWASP and Google (2021).
 */

private import internal.CryptoAlgorithmNames

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
 * Gets the most specific `CryptographicAlgorithm` that matches the given `name`.
 * A matching algorithm is one where the name of the algorithm matches the start of name, with allowances made for different name formats.
 * In the case that multiple `CryptographicAlgorithm`s match the given `name`, the algorithm(s) with the longest name will be selected. This is intended to select more specific versions of algorithms when multiple versions could match - for example "SHA3_224" matches against both "SHA3" and "SHA3224", but the latter is a more precise match.
 */
bindingset[name]
private CryptographicAlgorithm getBestAlgorithmForName(string name) {
  result =
    max(CryptographicAlgorithm algorithm |
      algorithm.getName() =
        [
          name.toUpperCase(), // the full name
          name.toUpperCase().regexpCapture("^([\\w]+)(?:-.*)?$", 1), // the name prior to any dashes or spaces
          name.toUpperCase().regexpCapture("^([A-Z0-9]+)(?:(-|_).*)?$", 1) // the name prior to any dashes, spaces, or underscores
        ].regexpReplaceAll("[-_ ]", "") // strip dashes, underscores, and spaces
    |
      algorithm order by algorithm.getName().length()
    )
}

/**
 * A cryptographic algorithm.
 */
abstract class CryptographicAlgorithm extends TCryptographicAlgorithm {
  /** Gets a textual representation of this element. */
  string toString() { result = this.getName() }

  /**
   * Gets the normalized name of this algorithm (upper-case, no spaces, dashes or underscores).
   */
  abstract string getName();

  /**
   * Holds if the name of this algorithm is the most specific match for `name`.
   * This predicate matches quite liberally to account for different ways of formatting algorithm names, e.g. using dashes, underscores, or spaces as separators, including or not including block modes of operation, etc.
   */
  bindingset[name]
  predicate matchesName(string name) { this = getBestAlgorithmForName(name) }

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

  /** Holds if this algorithm is a stream cipher. */
  predicate isStreamCipher() { isStreamCipher(name) }
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
