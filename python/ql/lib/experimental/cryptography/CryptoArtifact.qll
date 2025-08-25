import python
private import semmle.python.ApiGraphs
private import experimental.cryptography.CryptoAlgorithmNames
private import experimental.cryptography.utils.Utils as Utils

/*
 * A cryptographic artifact is a DataFlow::Node associated with some
 * operation, algorithm, or any other aspect of cryptography.
 */

abstract class CryptographicArtifact extends DataFlow::Node { }

/**
 * Associates a symmetric encryption algorithm with a block mode.
 * The DataFlow::Node representing this association should be the
 * point where the algorithm and block mode are combined.
 * This may be at the call to encryption or in the construction
 * of an object prior to encryption.
 */
abstract class SymmetricCipher extends CryptographicArtifact {
  abstract SymmetricEncryptionAlgorithm getEncryptionAlgorithm();

  abstract BlockMode getBlockMode();

  final predicate hasBlockMode() { exists(this.getBlockMode()) }
}

/**
 * A cryptographic operation is a method call that invokes a cryptographic
 * algorithm (encrypt/decrypt) or a function in support of a cryptographic algorithm
 * (key generation).
 *
 * Since operations are related to or in support of algorithms, operations must
 * provide a reference to their associated algorithm. Often operataions themselves
 * encapsulate algorithms, so operations can also extend CryptographicAlgorithm
 * and refer to themselves as the target algorithm.
 */
abstract class CryptographicOperation extends CryptographicArtifact, API::CallNode {
  bindingset[paramName, ind]
  final DataFlow::Node getParameterSource(int ind, string paramName) {
    result = Utils::getUltimateSrcFromApiNode(this.(API::CallNode).getParameter(ind, paramName))
  }

  final string getAlgorithmName() {
    if exists(this.getAlgorithm().getName())
    then result = this.getAlgorithm().getName()
    else result = unknownAlgorithm()
  }

  final predicate hasAlgorithm() { exists(this.getAlgorithm()) }

  final predicate isUnknownAlgorithm() {
    this.getAlgorithmName() = unknownAlgorithm()
    or
    not this.hasAlgorithm()
  }

  // TODO: this might have to be parameterized by a configuration source for
  //       situations where an operation is passed an algorithm
  abstract CryptographicAlgorithm getAlgorithm();
}

/** A key generation operation for asymmetric keys */
abstract class KeyGen extends CryptographicOperation {
  int getAKeySizeInBits() { result = this.getKeySizeInBits(_) }

  final predicate hasKeySize(DataFlow::Node configSrc) { exists(this.getKeySizeInBits(configSrc)) }

  final predicate hasKeySize() { exists(this.getAKeySizeInBits()) }

  abstract DataFlow::Node getKeyConfigSrc();

  abstract int getKeySizeInBits(DataFlow::Node configSrc);
}

abstract class AsymmetricKeyGen extends KeyGen { }

abstract class SymmetricKeyGen extends KeyGen { }

/**
 * A cryptographic algorithm is a `CryptographicArtifact`
 * representing a cryptographic algorithm (see `CryptoAlgorithmNames.qll`).
 * Cryptographic algorithms can be functions referencing common crypto algorithms (e.g., hashlib.md5)
 * or strings that are used in cryptographic operation configurations (e.g., hashlib.new("md5")).
 * Cryptogrpahic algorithms may also be operations that wrap or abstract one or
 * more algorithms (e.g., cyrptography.fernet.Fernet and AES, CBC and PKCS7).
 *
 * In principle, this class should model the location where an algorithm enters the program, not
 * necessarily where it is used.
 */
abstract class CryptographicAlgorithm extends CryptographicArtifact {
  abstract string getName();

  // TODO: handle case where name isn't known, not just unknown?
  /**
   * Normalizes a raw name into a normalized name as found in `CryptoAlgorithmNames.qll`.
   * Subclassess should override for more api-specific normalization.
   * By deafult, converts a raw name to upper-case with no hyphen, underscore, hash, or space.
   */
  bindingset[s]
  string normalizeName(string s) {
    exists(string normStr | normStr = s.toUpperCase().regexpReplaceAll("[-_ ]", "") |
      result = normStr and isKnownAlgorithm(result)
      or
      result = unknownAlgorithm() and not isKnownAlgorithm(normStr)
    )
  }
}

// class UnknownAlgorithm extends DataFlow::Node instanceof CryptographicAlgorithm{
//   UnknownAlgorithm(){
//     super.getName() = unknownAlgorithm()
//   }
// }
abstract class HashAlgorithm extends CryptographicAlgorithm {
  final string getHashName() {
    if exists(string n | n = this.getName() and isHashingAlgorithm(n))
    then isHashingAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }
}

abstract class KeyDerivationAlgorithm extends CryptographicAlgorithm {
  final string getKDFName() {
    if exists(string n | n = this.getName() and isKeyDerivationAlgorithm(n))
    then isKeyDerivationAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }
}

abstract class KeyDerivationOperation extends CryptographicOperation {
  DataFlow::Node getIterationSizeSrc() { none() }

  DataFlow::Node getSaltConfigSrc() { none() }

  DataFlow::Node getHashConfigSrc() { none() }

  // TODO: get encryption algorithm for CBC-based KDF?
  DataFlow::Node getDerivedKeySizeSrc() { none() }

  DataFlow::Node getModeSrc() { none() }

  // TODO: add more to cover all the parameters of most KDF operations? Perhaps subclass for each type?
  abstract predicate requiresIteration();

  abstract predicate requiresSalt();

  abstract predicate requiresHash();

  //abstract predicate requiresKeySize(); // Going to assume all requires a size
  abstract predicate requiresMode();
}

/**
 * A parent class to represent any algorithm for which
 * asymmetric cryptography is involved.
 * Intended to be distinct from AsymmetricEncryptionAlgorithm
 * which is intended only for asymmetric algorithms that specifically encrypt.
 */
abstract class AsymmetricAlgorithm extends CryptographicAlgorithm { }

abstract class EncryptionAlgorithm extends CryptographicAlgorithm {
  final predicate isAsymmetric() { this instanceof AsymmetricEncryptionAlgorithm }

  final predicate isSymmetric() { not this.isAsymmetric() }
  // NOTE: DO_NOT add getEncryptionName here, we rely on the fact the parent
  //       class does not have this common predicate.
}

/**
 * Algorithms directly or indirectly related to asymmetric encryption,
 * e.g., RSA, DSA, but also RSA padding algorithms
 */
abstract class AsymmetricEncryptionAlgorithm extends AsymmetricAlgorithm, EncryptionAlgorithm {
  final string getEncryptionName() {
    if exists(string n | n = this.getName() and isAsymmetricEncryptionAlgorithm(n))
    then isAsymmetricEncryptionAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }
}

/**
 * Algorithms directly or indirectly related to symmetric encryption,
 * e.g., AES, DES, but also block modes and padding
 */
abstract class SymmetricEncryptionAlgorithm extends EncryptionAlgorithm {
  final string getEncryptionName() {
    if exists(string n | n = this.getName() and isSymmetricEncryptionAlgorithm(n))
    then isSymmetricEncryptionAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }
  // TODO: add a stream cipher predicate?
}

// Used only to categorize all padding into a single object,
// DO_NOT add predicates here. Only for categorization purposes.
abstract class PaddingAlgorithm extends CryptographicAlgorithm { }

abstract class SymmetricPadding extends PaddingAlgorithm {
  final string getPaddingName() {
    if exists(string n | n = this.getName() and isSymmetricPaddingAlgorithm(n))
    then isSymmetricPaddingAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }
}

abstract class AsymmetricPadding extends PaddingAlgorithm {
  final string getPaddingName() {
    if exists(string n | n = this.getName() and isAsymmetricPaddingAlgorithm(n))
    then isAsymmetricPaddingAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }
}

abstract class EllipticCurveAlgorithm extends AsymmetricAlgorithm {
  final string getCurveName() {
    if exists(string n | n = this.getName() and isEllipticCurveAlgorithm(n))
    then isEllipticCurveAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }

  final int getCurveBitSize() { isEllipticCurveAlgorithm(this.getCurveName(), result) }
}

abstract class BlockMode extends CryptographicAlgorithm {
  final string getBlockModeName() {
    if exists(string n | n = this.getName() and isCipherBlockModeAlgorithm(n))
    then isCipherBlockModeAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }

  /**
   * Gets the source of the IV configuration.
   */
  abstract DataFlow::Node getIVorNonce();

  final predicate hasIVorNonce() { exists(this.getIVorNonce()) }
}

abstract class KeyWrapOperation extends CryptographicOperation { }

abstract class AuthenticatedEncryptionAlgorithm extends SymmetricEncryptionAlgorithm {
  final string getAuthticatedEncryptionName() {
    if exists(string n | n = this.getName() and isSymmetricEncryptionAlgorithm(n))
    then isSymmetricEncryptionAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }
}

abstract class KeyExchangeAlgorithm extends AsymmetricAlgorithm {
  final string getKeyExchangeName() {
    if exists(string n | n = this.getName() and isKeyExchangeAlgorithm(n))
    then isKeyExchangeAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }
}

abstract class SigningAlgorithm extends AsymmetricAlgorithm {
  final string getSigningName() {
    if exists(string n | n = this.getName() and isSignatureAlgorithm(n))
    then isSignatureAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }
}
