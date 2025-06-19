private import csharp
private import experimental.quantum.Language
private import AlgorithmValueConsumers
private import Cryptography
private import FlowAnalysis

class SigningNamedCurveAlgorithmInstance extends Crypto::EllipticCurveInstance instanceof SigningNamedCurvePropertyAccess
{
  ECDsaAlgorithmValueConsumer consumer;

  SigningNamedCurveAlgorithmInstance() {
    SigningNamedCurveToSignatureCreateFlow::flow(DataFlow::exprNode(this), consumer.getInputNode())
  }

  ECDsaAlgorithmValueConsumer getConsumer() { result = consumer }

  override string getRawEllipticCurveName() { result = super.getCurveName() }

  override Crypto::TEllipticCurveType getEllipticCurveType() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName(), _, result)
  }

  override int getKeySize() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName(), result, _)
  }
}
