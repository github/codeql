/**
 * Provides classes for modeling cryptographic libraries.
 */

import go

/**
 * Names of cryptographic algorithms, separated into strong and weak variants.
 * The names are normalized: upper-case, no spaces, dashes or underscores.
 * The names are inspired by the names used in real world crypto libraries.
 * The classification into strong and weak are based on Wikipedia, OWASP and google (2017).
 */
private module AlgorithmNames {
  predicate isWeakHashingAlgorithm(string name) {
    name = "MD5" or
    name = "SHA1"
  }

  predicate isWeakEncryptionAlgorithm(string name) {
    name = "DES" or
    name = "RC4"
  }
}

private import AlgorithmNames

/**
 * A cryptographic algorithm.
 */
private newtype TCryptographicAlgorithm =
  MkHashingAlgorithm(string name, boolean isWeak) { isWeakHashingAlgorithm(name) and isWeak = true } or
  MkEncryptionAlgorithm(string name, boolean isWeak) {
    isWeakEncryptionAlgorithm(name) and isWeak = true
  }

/**
 * A cryptographic algorithm.
 */
abstract class CryptographicAlgorithm extends TCryptographicAlgorithm {
  /** Gets a textual representation of this element. */
  string toString() { result = getName() }

  /**
   * Gets the name of this algorithm.
   */
  abstract string getName();

  /**
   * Holds if the name of this algorithm matches `name` modulo case, white space, dashes and underscores.
   */
  bindingset[name]
  predicate matchesName(string name) {
    exists(name.regexpReplaceAll("[-_]", "").regexpFind("(?i)\\Q" + getName() + "\\E", _, _))
  }

  /**
   * Holds if this algorithm is weak.
   */
  abstract predicate isWeak();
}

/**
 * A hashing algorithm
 */
class HashingAlgorithm extends MkHashingAlgorithm, CryptographicAlgorithm {
  string name;
  boolean isWeak;

  HashingAlgorithm() { this = MkHashingAlgorithm(name, isWeak) }

  override string getName() { result = name }

  override predicate isWeak() { isWeak = true }
}

/**
 * An encryption algorithm
 */
class EncryptionAlgorithm extends MkEncryptionAlgorithm, CryptographicAlgorithm {
  string name;
  boolean isWeak;

  EncryptionAlgorithm() { this = MkEncryptionAlgorithm(name, isWeak) }

  override string getName() { result = name }

  override predicate isWeak() { isWeak = true }
}

/**
 * An application of a cryptographic algorithm.
 */
abstract class CryptographicOperation extends Expr {
  /**
   * Gets the applied algorithm.
   */
  abstract CryptographicAlgorithm getAlgorithm();
}

/**
 * Class that checks for use of Md5 package.
 */
class Md5 extends CryptographicOperation {
  CryptographicAlgorithm algorithm;
  SelectorExpr sel;
  CallExpr call;

  Md5() {
    this = call and
    algorithm.matchesName(sel.getBase().toString()) and
    algorithm.matchesName("MD5") and
    sel.getSelector().toString() = call.getCalleeName().toString() and
    (
      call.getCalleeName().toString() = "New" or
      call.getCalleeName().toString() = "Sum"
    )
  }

  override CryptographicAlgorithm getAlgorithm() { result = algorithm }
}

/**
 * Class that checks for use of SHA1 package.
 */
class Sha1 extends CryptographicOperation {
  CryptographicAlgorithm algorithm;
  SelectorExpr sel;
  CallExpr call;

  Sha1() {
    this = call and
    algorithm.matchesName(sel.getBase().toString()) and
    algorithm.matchesName("SHA1") and
    sel.getSelector().toString() = call.getCalleeName().toString() and
    (
      call.getCalleeName().toString() = "New" or
      call.getCalleeName().toString() = "Sum"
    )
  }

  override CryptographicAlgorithm getAlgorithm() { result = algorithm }
}

/**
 * Class that checks for use of Des package.
 */
class Des extends CryptographicOperation {
  CryptographicAlgorithm algorithm;
  SelectorExpr sel;
  CallExpr call;

  Des() {
    this = call and
    algorithm.matchesName(sel.getBase().toString()) and
    algorithm.matchesName("DES") and
    sel.getSelector().toString() = call.getCalleeName().toString() and
    (
      call.getCalleeName().toString() = "NewCipher" or
      call.getCalleeName().toString() = "NewTripleDESCipher"
    )
  }

  override CryptographicAlgorithm getAlgorithm() { result = algorithm }
}

/**
 * Class that checks for use of RC4 package.
 */
class Rc4 extends CryptographicOperation {
  CryptographicAlgorithm algorithm;
  SelectorExpr sel;
  CallExpr call;

  Rc4() {
    this = call and
    algorithm.matchesName(sel.getBase().toString()) and
    algorithm.matchesName("RC4") and
    sel.getSelector().toString() = call.getCalleeName().toString() and
    call.getCalleeName().toString() = "NewCipher"
  }

  override CryptographicAlgorithm getAlgorithm() { result = algorithm }
}
