private import csharp
private import experimental.quantum.Language
private import AlgorithmValueConsumers
private import Cryptography
private import FlowAnalysis

class NamedCurveAlgorithmInstance extends Crypto::EllipticCurveInstance instanceof SigningNamedCurvePropertyAccess
{
  ECDsaAlgorithmValueConsumer consumer;

  NamedCurveAlgorithmInstance() {
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

class EcdsaAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance instanceof ECDsaCreateCall
{
  EcdsaAlgorithmInstance() {
    // SigningNamedCurveToSignatureCreateFlow::flow(DataFlow::exprNode(this), consumer.getInputNode())
    this instanceof ECDsaCreateCall
  }

  ECDsaAlgorithmValueConsumer getConsumer() { result = super.getQualifier() }

  override string getRawAlgorithmName() { result = "ECDsa" }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  // TODO: PaddingAlgorithmInstance errors with "call to empty relation: class test for Model::CryptographyBase::PaddingAlgorithmInstance"
  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }
  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override int getKeySizeFixed() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::ECDSA())
  }
}

class HashAlgorithmNameInstance extends Crypto::HashAlgorithmInstance instanceof HashAlgorithmName {
  HashAlgorithmNameConsumer consumer;

  HashAlgorithmNameInstance() {
    HashAlgorithmNameToUse::flow(DataFlow::exprNode(this), consumer.getInputNode())
  }

  override Crypto::THashType getHashFamily() { result = this.(HashAlgorithmName).getHashFamily() }

  override string getRawHashAlgorithmName() { result = super.getAlgorithmName() }

  override int getFixedDigestLength() { result = this.(HashAlgorithmName).getFixedDigestLength() }

  Crypto::AlgorithmValueConsumer getConsumer() { result = consumer }
}
