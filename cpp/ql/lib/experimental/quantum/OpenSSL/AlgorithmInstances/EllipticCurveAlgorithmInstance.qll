import cpp
import experimental.quantum.Language
import KnownAlgorithmConstants
import OpenSSLAlgorithmInstanceBase
import AlgToAVCFlow

//ellipticCurveNameToKeySizeAndFamilyMapping(name, size, family)
class KnownOpenSSLEllitpicCurveConstantAlgorithmInstance extends OpenSSLAlgorithmInstance,
  Crypto::EllipticCurveInstance instanceof KnownOpenSSLEllipticCurveAlgorithmConstant
{
  OpenSSLAlgorithmValueConsumer getterCall;

  KnownOpenSSLEllitpicCurveConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSSLAlgorithm is call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof Literal and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.(OpenSSLAlgorithmValueConsumer).getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSSLAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink)
    )
    or
    // Possibility 2:
    this instanceof DirectAlgorithmValueConsumer and getterCall = this
  }

  override OpenSSLAlgorithmValueConsumer getAVC() { result = getterCall }

  override string getRawEllipticCurveName() { result = this.(Literal).getValue().toString() }

  override Crypto::TEllipticCurveType getEllipticCurveType() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.(KnownOpenSSLEllipticCurveAlgorithmConstant)
          .getNormalizedName(), _, result)
  }

  override int getKeySize() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.(KnownOpenSSLEllipticCurveAlgorithmConstant)
          .getNormalizedName(), result, _)
  }
}
