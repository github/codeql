import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import AlgToAVCFlow

predicate knownOpenSSLConstantToKeyAgreementFamilyType(
  KnownOpenSSLKeyAgreementAlgorithmExpr e, Crypto::TKeyAgreementType type
) {
  exists(string name |
    name = e.(KnownOpenSSLAlgorithmExpr).getNormalizedName() and
    (
      name = "ECDH" and type = Crypto::ECDH()
      or
      name = "DH" and type = Crypto::DH()
      or
      name = "EDH" and type = Crypto::EDH()
      or
      name = "ESDH" and type = Crypto::EDH()
    )
  )
}

class KnownOpenSSLHashConstantAlgorithmInstance extends OpenSSLAlgorithmInstance,
  Crypto::KeyAgreementAlgorithmInstance instanceof KnownOpenSSLKeyAgreementAlgorithmExpr
{
  OpenSSLAlgorithmValueConsumer getterCall;

  KnownOpenSSLHashConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSSLAlgorithm is call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof OpenSSLAlgorithmLiteral and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSSLAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink)
    )
    or
    // Possibility 2:
    this instanceof OpenSSLAlgorithmCall and
    this instanceof DirectAlgorithmValueConsumer and
    getterCall = this
  }

  override OpenSSLAlgorithmValueConsumer getAVC() { result = getterCall }

  override Crypto::TKeyAgreementType getKeyAgreementType() {
    knownOpenSSLConstantToKeyAgreementFamilyType(this, result)
    or
    not knownOpenSSLConstantToKeyAgreementFamilyType(this, _) and
    result = Crypto::OtherKeyAgreementType()
  }

  override string getRawKeyAgreementAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }
}
