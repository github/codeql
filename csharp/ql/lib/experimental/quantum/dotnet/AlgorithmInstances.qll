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

class HashAlgorithmInstance extends Crypto::HashAlgorithmInstance instanceof HashAlgorithmName {
  HashAlgorithmConsumer consumer;

  HashAlgorithmInstance() {
    HashAlgorithmNameToUse::flow(DataFlow::exprNode(this), consumer.getInputNode())
  }

  // Q: super.getHashFamily does not work because it is ambigous. But super.(HashAlgorithmName) does not work either.
  override Crypto::THashType getHashFamily() { result = this.(HashAlgorithmName).getHashFamily() }

  override string getRawHashAlgorithmName() { result = super.getAlgorithmName() }

  override int getFixedDigestLength() { result = this.(HashAlgorithmName).getFixedDigestLength() }

  Crypto::AlgorithmValueConsumer getConsumer() { result = consumer }
}
