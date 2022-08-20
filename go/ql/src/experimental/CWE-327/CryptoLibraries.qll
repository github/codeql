/**
 * Provides classes for modeling cryptographic libraries.
 */

import go

/**
 * Names of cryptographic algorithms, separated into strong and weak variants.
 *
 * The names are normalized: upper-case, no spaces, dashes or underscores.
 *
 * The names are inspired by the names used in real world crypto libraries.
 *
 * The classification into strong and weak are based on OWASP and Wikipedia (2020).
 *
 * Sources (more links in qhelp file):
 * https://en.wikipedia.org/wiki/Strong_cryptography#Cryptographically_strong_algorithms
 * https://en.wikipedia.org/wiki/Strong_cryptography#Examples
 * https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html
 */
private module AlgorithmNames {
  predicate isStrongHashingAlgorithm(string name) {
    name =
      [
        "DSA", "ED25519", "SHA256", "SHA384", "SHA512", "SHA3", "ES256", "ECDSA256", "ES384",
        "ECDSA384", "ES512", "ECDSA512", "SHA2", "SHA224"
      ]
  }

  predicate isWeakHashingAlgorithm(string name) {
    name =
      [
        "HAVEL128", "MD2", "SHA1", "MD4", "MD5", "PANAMA", "RIPEMD", "RIPEMD128", "RIPEMD256",
        "RIPEMD320", "SHA0"
      ]
  }

  predicate isStrongEncryptionAlgorithm(string name) {
    name = ["AES", "AES128", "AES192", "AES256", "AES512", "RSA", "RABBIT", "BLOWFISH"]
  }

  predicate isWeakEncryptionAlgorithm(string name) {
    name =
      [
        "DES", "3DES", "ARC5", "RC5", "TRIPLEDES", "TDEA", "TRIPLEDEA", "ARC2", "RC2", "ARC4",
        "RC4", "ARCFOUR"
      ]
  }

  predicate isStrongPasswordHashingAlgorithm(string name) {
    name = ["ARGON2", "PBKDF2", "BCRYPT", "SCRYPT"]
  }

  predicate isWeakPasswordHashingAlgorithm(string name) { none() }
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
  string toString() { result = this.getName() }

  /**
   * Gets the name of this algorithm.
   */
  abstract string getName();

  /**
   * Holds if the name of this algorithm matches `name` modulo case,
   * white space, dashes and underscores.
   */
  bindingset[name]
  predicate matchesName(string name) {
    exists(name.regexpReplaceAll("[-_]", "").regexpFind("(?i)\\Q" + this.getName() + "\\E", _, _))
  }

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

/**
 * An application of a cryptographic algorithm.
 */
abstract class CryptographicOperation extends DataFlow::Node {
  /**
   * Gets the input the algorithm is used on, e.g. the plain text input to be encrypted.
   */
  abstract Expr getInput();

  /**
   * Gets the applied algorithm.
   */
  abstract CryptographicAlgorithm getAlgorithm();
}

/**
 * Models cryptographic operations of the `crypto/md5` package.
 */
class Md5 extends CryptographicOperation, DataFlow::CallNode {
  Md5() { this.getTarget().hasQualifiedName("crypto/md5", ["New", "Sum"]) }

  override Expr getInput() { result = this.getArgument(0).asExpr() }

  override CryptographicAlgorithm getAlgorithm() {
    result.matchesName(this.getTarget().getPackage().getName())
  }
}

/**
 * Models cryptographic operations of the `crypto/sha1` package.
 */
class Sha1 extends CryptographicOperation, DataFlow::CallNode {
  Sha1() { this.getTarget().hasQualifiedName("crypto/sha1", ["New", "Sum"]) }

  override Expr getInput() { result = this.getArgument(0).asExpr() }

  override CryptographicAlgorithm getAlgorithm() {
    result.matchesName(this.getTarget().getPackage().getName())
  }
}

/**
 * Models cryptographic operations of the `crypto/des` package.
 */
class Des extends CryptographicOperation, DataFlow::CallNode {
  Des() { this.getTarget().hasQualifiedName("crypto/des", ["NewCipher", "NewTripleDESCipher"]) }

  override Expr getInput() { result = this.getArgument(0).asExpr() }

  override CryptographicAlgorithm getAlgorithm() {
    result.matchesName(this.getTarget().getPackage().getName())
  }
}

/**
 * Models cryptographic operations of the `crypto/rc4` package.
 */
class Rc4 extends CryptographicOperation, DataFlow::CallNode {
  Rc4() { this.getTarget().hasQualifiedName("crypto/rc4", ["NewCipher"]) }

  override Expr getInput() { result = this.getArgument(0).asExpr() }

  override CryptographicAlgorithm getAlgorithm() {
    result.matchesName(this.getTarget().getPackage().getName())
  }
}
