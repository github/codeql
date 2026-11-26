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
private predicate knownOpenSslConstantToSignatureFamilyType(
  KnownOpenSslSignatureAlgorithmExpr e, Crypto::KeyOpAlg::TAlgorithm type
) {
  exists(string name |
    name = e.(KnownOpenSslAlgorithmExpr).getNormalizedName() and
    (
      name.startsWith("RSA") and type = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA())
      or
      name.startsWith("DSA") and type = KeyOpAlg::TSignature(KeyOpAlg::DSA())
      or
      name.startsWith("ECDSA") and type = KeyOpAlg::TSignature(KeyOpAlg::ECDSA())
      or
      name.startsWith("ED25519") and type = KeyOpAlg::TSignature(KeyOpAlg::EDDSA())
      or
      name.startsWith("ED448") and type = KeyOpAlg::TSignature(KeyOpAlg::EDDSA())
    )
  )
}

/**
 * A signature algorithm instance derived from an OpenSsl constant.
 */
class KnownOpenSslSignatureConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::KeyOperationAlgorithmInstance instanceof KnownOpenSslSignatureAlgorithmExpr
{
  OpenSslAlgorithmValueConsumer getterCall;

  KnownOpenSslSignatureConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSslAlgorithm call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof OpenSslAlgorithmLiteral and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a signature getter call
      sink = getterCall.getInputNode() and
      // Source is `this`
      // NOTE: src literals can be ints or strings, so need to consider asExpr and asIndirectExpr
      this = [src.asExpr(), src.asIndirectExpr()] and
      // This traces to a getter
      KnownOpenSslAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink)
    )
    or
    // Possibility 2:
    this instanceof OpenSslAlgorithmCall and
    getterCall = this
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override string getRawAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override int getKeySizeFixed() {
    // TODO: use ellipticCurveNameToKeySizeAndFamilyMapping or KnownOpenSslEllipticCurveConstantAlgorithmInstance
    // TODO: maybe add getExplicitKeySize to KnownOpenSslSignatureAlgorithmExpr and use it here
    none()
  }

  override KeyOpAlg::AlgorithmType getAlgorithmType() {
    knownOpenSslConstantToSignatureFamilyType(this, result)
    or
    not knownOpenSslConstantToSignatureFamilyType(this, _) and
    result = KeyOpAlg::TSignature(KeyOpAlg::OtherSignatureAlgorithmType())
  }

  override OpenSslAlgorithmValueConsumer getAvc() { result = getterCall }

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
