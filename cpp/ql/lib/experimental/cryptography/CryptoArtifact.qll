import cpp
private import experimental.cryptography.CryptoAlgorithmNames
import semmle.code.cpp.ir.dataflow.TaintTracking

/*
 * A cryptographic artifact is a DataFlow::Node associated with some
 * operation, algorithm, or any other aspect of cryptography.
 */

abstract class CryptographicArtifact extends Expr { }

// /**
//  * Associates a symmetric encryption algorithm with a block mode.
//  * The DataFlow::Node representing this association should be the
//  * point where the algorithm and block mode are combined.
//  * This may be at the call to encryption or in the construction
//  * of an object prior to encryption.
//  */
// abstract class SymmetricCipher extends CryptographicArtifact{
//   abstract SymmetricEncryptionAlgorithm getEncryptionAlgorithm();
//   abstract BlockMode getBlockMode();
//   final predicate hasBlockMode(){
//     exists(this.getBlockMode())
//   }
// }
// /**
//  * A cryptographic operation is a method call that invokes a cryptographic
//  * algorithm (encrypt/decrypt) or a function in support of a cryptographic algorithm
//  * (key generation).
//  *
//  * Since operations are related to or in support of algorithms, operations must
//  * provide a reference to their associated algorithm. Often operataions themselves
//  * encapsulate algorithms, so operations can also extend CryptographicAlgorithm
//  * and refer to themselves as the target algorithm.
//  */
// abstract class CryptographicOperation extends CryptographicArtifact, Call{
//   // bindingset[paramName, ind]
//   // final DataFlow::Node getParameterSource(int ind, string paramName){
//   //   result = Utils::getUltimateSrcFromApiNode(this.(API::CallNode).getParameter(ind, paramName))
//   // }
//   final string getAlgorithmName(){
//     if exists(this.getAlgorithm().getName())
//     then result = this.getAlgorithm().getName()
//     else result = unknownAlgorithm()
//   }
//   final predicate hasAlgorithm(){
//     exists(this.getAlgorithm())
//   }
//   final predicate isUnknownAlgorithm(){
//     this.getAlgorithmName() = unknownAlgorithm()
//     or
//     not this.hasAlgorithm()
//   }
//   // TODO: this might have to be parameterized by a configuration source for
//   //       situations where an operation is passed an algorithm
//   abstract CryptographicAlgorithm getAlgorithm();
// }
// /** A key generation operation for asymmetric keys */
// abstract class KeyGen extends CryptographicOperation{
//   int getAKeySizeInBits(){
//     result = getKeySizeInBits(_)
//   }
//   final predicate hasKeySize(Expr configSrc){
//     exists(this.getKeySizeInBits(configSrc))
//   }
//   final predicate hasKeySize(){
//     exists(this.getAKeySizeInBits())
//   }
//   abstract Expr getKeyConfigSrc();
//   abstract int getKeySizeInBits(Expr configSrc);
// }
abstract class CryptographicOperation extends CryptographicArtifact, Call { }

abstract class KeyGeneration extends CryptographicOperation {
  // TODO: what if the algorithm is UNKNOWN?
  abstract Expr getKeyConfigurationSource(CryptographicAlgorithm alg);

  abstract CryptographicAlgorithm getAlgorithm();

  int getKeySizeInBits(CryptographicAlgorithm alg) {
    result = this.getKeyConfigurationSource(alg).(Literal).getValue().toInt()
  }

  predicate hasConstantKeySize(CryptographicAlgorithm alg) { exists(this.getKeySizeInBits(alg)) }

  predicate hasKeyConfigurationSource(CryptographicAlgorithm alg) {
    exists(this.getKeyConfigurationSource(alg))
  }

  Expr getAKeyConfigurationSource() { result = this.getKeyConfigurationSource(_) }
}

abstract class AsymmetricKeyGeneration extends KeyGeneration { }

abstract class SymmetricKeyGeneration extends KeyGeneration { }

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

  abstract string getAlgType();

  //  string getAlgType(){
  //   if this instanceof HashAlgorithm then result = getHashType()
  //   else if this instanceof KeyDerivationAlgorithm then result = getKeyDerivationType()
  //   else if this instanceof SymmetricEncryptionAlgorithm then result = getSymmetricEncryptionType()
  //   else if this instanceof AsymmetricEncryptionAlgorithm then result = getAsymmetricEncryptionType()
  //   else if this instanceof SymmetricEncryptionAlgorithm then result = getSymmetricPaddingType()
  //   else if this instanceof AsymmetricEncryptionAlgorithm then result = getAsymmetricPaddingType()
  //   else if this instanceof EllipticCurveAlgorithm then result = getEllipticCurveType()
  //   else if this instanceof BlockMode then result = getCipherBlockModeType()
  //   else if this instanceof KeyExchangeAlgorithm then result = getKeyExchangeType()
  //   else if this instanceof SigningAlgorithm then result = getSignatureType()
  //   else result = unknownAlgorithm()
  // }
  // TODO: handle case where name isn't known, not just unknown?
  /**
   * Normalizes a raw name into a normalized name as found in `CryptoAlgorithmNames.qll`.
   * Subclassess should override for more api-specific normalization.
   * By deafult, converts a raw name to upper-case with no hyphen, underscore, hash, or space.
   */
  bindingset[s]
  string normalizeName(string s) {
    exists(string normStr | normStr = s.toUpperCase().regexpReplaceAll("[-_ ]|/", "") |
      result = normStr and isKnownAlgorithm(result)
      or
      result = unknownAlgorithm() and not isKnownAlgorithm(normStr)
    )
  }

  abstract Expr configurationSink();

  predicate hasConfigurationSink() { exists(this.configurationSink()) }
}

abstract class HashAlgorithm extends CryptographicAlgorithm {
  final string getHashName() {
    if exists(string n | n = this.getName() and isHashingAlgorithm(n))
    then isHashingAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }

  override string getAlgType() { result = getHashType() }
}

abstract class KeyDerivationAlgorithm extends CryptographicAlgorithm {
  final string getKDFName() {
    if exists(string n | n = this.getName() and isKeyDerivationAlgorithm(n))
    then isKeyDerivationAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }

  override string getAlgType() { result = getKeyDerivationType() }
}

// abstract class KeyDerivationOperation extends CryptographicOperation{
//   DataFlow::Node getIterationSizeSrc(){
//     none()
//   }
//   DataFlow::Node getSaltConfigSrc(){
//     none()
//   }
//   DataFlow::Node getHashConfigSrc(){
//     none()
//   }
//   // TODO: get encryption algorithm for CBC-based KDF?
//   DataFlow::Node getDerivedKeySizeSrc(){
//     none()
//   }
//   DataFlow::Node getModeSrc(){
//     none()
//   }
//   // TODO: add more to cover all the parameters of most KDF operations? Perhaps subclass for each type?
//   abstract predicate requiresIteration();
//   abstract predicate requiresSalt();
//   abstract predicate requiresHash();
//   //abstract predicate requiresKeySize(); // Going to assume all requires a size
//   abstract predicate requiresMode();
// }
abstract class EncryptionAlgorithm extends CryptographicAlgorithm {
  final predicate isAsymmetric() { this instanceof AsymmetricEncryptionAlgorithm }

  final predicate isSymmetric() { not this.isAsymmetric() }
  // NOTE: DO_NOT add getEncryptionName here, we rely on the fact the parent
  //       class does not have this common predicate.
}

/**
 * A parent class to represent any algorithm for which
 * asymmetric cryptography is involved.
 * Intended to be distinct from AsymmetricEncryptionAlgorithm
 * which is intended only for asymmetric algorithms that specifically encrypt.
 */
abstract class AsymmetricAlgorithm extends CryptographicAlgorithm { }

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

  override string getAlgType() { result = getAsymmetricEncryptionType() }
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
  override string getAlgType() { result = getSymmetricEncryptionType() }
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

  override string getAlgType() { result = getSymmetricPaddingType() }
}

abstract class AsymmetricPadding extends PaddingAlgorithm {
  final string getPaddingName() {
    if exists(string n | n = this.getName() and isAsymmetricPaddingAlgorithm(n))
    then isAsymmetricPaddingAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }

  override string getAlgType() { result = getAsymmetricPaddingType() }
}

abstract class EllipticCurveAlgorithm extends AsymmetricAlgorithm {
  final string getCurveName() {
    if exists(string n | n = this.getName() and isEllipticCurveAlgorithm(n))
    then isEllipticCurveAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }

  final int getCurveBitSize() { isEllipticCurveAlgorithm(this.getCurveName(), result) }

  override string getAlgType() { result = getEllipticCurveType() }
}

abstract class BlockModeAlgorithm extends CryptographicAlgorithm {
  final string getBlockModeName() {
    if exists(string n | n = this.getName() and isCipherBlockModeAlgorithm(n))
    then isCipherBlockModeAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }

  /**
   * Gets the source of the IV configuration.
   */
  abstract Expr getIVorNonce();

  final predicate hasIVorNonce() { exists(this.getIVorNonce()) }

  override string getAlgType() { result = getCipherBlockModeType() }
}

// abstract class KeyWrapOperation extends CryptographicOperation{
// }
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

  override string getAlgType() { result = getKeyExchangeType() }
}

abstract class SigningAlgorithm extends AsymmetricAlgorithm {
  final string getSigningName() {
    if exists(string n | n = this.getName() and isSignatureAlgorithm(n))
    then isSignatureAlgorithm(result) and result = this.getName()
    else result = unknownAlgorithm()
  }

  override string getAlgType() { result = getSignatureType() }
}
