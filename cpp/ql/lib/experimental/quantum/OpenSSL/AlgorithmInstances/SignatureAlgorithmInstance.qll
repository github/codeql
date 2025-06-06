import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import Crypto::KeyOpAlg as KeyOpAlg
private import OpenSSLAlgorithmInstanceBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.DirectAlgorithmValueConsumer
private import AlgToAVCFlow

/**
 * Gets the signature algorithm type based on the normalized algorithm name.
 */
private predicate knownOpenSSLConstantToSignatureFamilyType(
  KnownOpenSSLSignatureAlgorithmConstant e, Crypto::KeyOpAlg::TAlgorithm type
) {
  exists(string name |
    name = e.getNormalizedName() and
    (
      name.matches("RSA%") and type = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA())
      or
      name.matches("DSA%") and type = KeyOpAlg::TSignature(KeyOpAlg::DSA())
      or
      name.matches("ECDSA%") and type = KeyOpAlg::TSignature(KeyOpAlg::ECDSA())
      or
      name.matches("ED25519%") and type = KeyOpAlg::TSignature(KeyOpAlg::Ed25519())
      or
      name.matches("ED448%") and type = KeyOpAlg::TSignature(KeyOpAlg::Ed448())
      // or
      // name.matches("sm2%") and type = KeyOpAlg::TSignature(KeyOpAlg::SM2())
      // or
      // name.matches("ml-dsa%") and type = KeyOpAlg::TSignature(KeyOpAlg::MLDSA())
      // or
      // name.matches("slh-dsa%") and type = KeyOpAlg::TSignature(KeyOpAlg::SLHDSA())
    )
  )
}

/**
 * A signature algorithm instance derived from an OpenSSL constant.
 */
class KnownOpenSSLSignatureConstantAlgorithmInstance extends OpenSSLAlgorithmInstance,
  Crypto::KeyOperationAlgorithmInstance instanceof KnownOpenSSLSignatureAlgorithmConstant
{
  OpenSSLAlgorithmValueConsumer getterCall;

  KnownOpenSSLSignatureConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSSLAlgorithm call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof Literal and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a signature getter call
      sink = getterCall.getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSSLAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink)
    )
    or
    // Possibility 2:
    this instanceof DirectAlgorithmValueConsumer and getterCall = this
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override string getRawAlgorithmName() { result = this.(Literal).getValue().toString() }

  override int getKeySizeFixed() {
    // TODO: use ellipticCurveNameToKeySizeAndFamilyMapping or KnownOpenSSLEllipticCurveConstantAlgorithmInstance
    // TODO: maybe add getExplicitKeySize to KnownOpenSSLSignatureAlgorithmConstant and use it here
    none()
  }

  override KeyOpAlg::Algorithm getAlgorithmType() {
    knownOpenSSLConstantToSignatureFamilyType(this, result)
    or
    not knownOpenSSLConstantToSignatureFamilyType(this, _) and
    result = KeyOpAlg::TSignature(KeyOpAlg::OtherSignatureAlgorithmType())
  }

  override OpenSSLAlgorithmValueConsumer getAVC() { result = getterCall }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    // TODO: trace to any key size initializer
    // probably PKeyAlgorithmValueConsumer and SignatureAlgorithmValueConsumer
    none()
  }

  /**
   * No mode for signatures.
   */
  override predicate shouldHaveModeOfOperation() { none() }

  /**
   * Padding only for RSA.
   */
  override predicate shouldHavePaddingScheme() {
    this.getAlgorithmType() instanceof KeyOpAlg::TAsymmetricCipher
  }
}
