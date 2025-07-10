import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import AlgToAVCFlow

predicate knownOpenSslConstantToKeyAgreementFamilyType(
  KnownOpenSslKeyAgreementAlgorithmExpr e, Crypto::TKeyAgreementType type
) {
  exists(string name |
    name = e.(KnownOpenSslAlgorithmExpr).getNormalizedName() and
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

class KnownOpenSslKeyAgreementConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::KeyAgreementAlgorithmInstance instanceof KnownOpenSslKeyAgreementAlgorithmExpr
{
  OpenSslAlgorithmValueConsumer getterCall;

  KnownOpenSslKeyAgreementConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSslAlgorithm is call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof OpenSslAlgorithmLiteral and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSslAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink)
    )
    or
    // Possibility 2:
    this instanceof OpenSslAlgorithmCall and
    getterCall = this
  }

  override OpenSslAlgorithmValueConsumer getAvc() { result = getterCall }

  override Crypto::TKeyAgreementType getKeyAgreementType() {
    knownOpenSslConstantToKeyAgreementFamilyType(this, result)
    or
    not knownOpenSslConstantToKeyAgreementFamilyType(this, _) and
    result = Crypto::OtherKeyAgreementType()
  }

  override string getRawKeyAgreementAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }
}
