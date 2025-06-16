import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import OpenSSLAlgorithmInstanceBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.DirectAlgorithmValueConsumer
private import AlgToAVCFlow

class KnownOpenSslEllipticCurveConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::EllipticCurveInstance instanceof KnownOpenSslEllipticCurveAlgorithmExpr
{
  OpenSslAlgorithmValueConsumer getterCall;

  KnownOpenSslEllipticCurveConstantAlgorithmInstance() {
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

  override string getRawEllipticCurveName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override Crypto::TEllipticCurveType getEllipticCurveType() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getParsedEllipticCurveName(), _, result)
  }

  override string getParsedEllipticCurveName() {
    result = this.(KnownOpenSslAlgorithmExpr).getNormalizedName()
  }

  override int getKeySize() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.(KnownOpenSslAlgorithmExpr)
          .getNormalizedName(), result, _)
  }
}
