private import csharp
private import experimental.quantum.Language
private import AlgorithmValueConsumers
private import OperationInstances
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

class SymmetricAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance instanceof SymmetricAlgorithmCreation
{
  override string getRawAlgorithmName() { result = super.getSymmetricAlgorithm().getName() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    if exists(symmetricAlgorithmNameToType(this.getRawAlgorithmName()))
    then result = symmetricAlgorithmNameToType(this.getRawAlgorithmName())
    else result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::OtherSymmetricCipherType())
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override int getKeySizeFixed() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }
}

/**
 * A padding mode literal, such as `PaddingMode.PKCS7`.
 */
class PaddingModeLiteralInstance extends Crypto::PaddingAlgorithmInstance instanceof MemberConstantAccess
{
  Crypto::AlgorithmValueConsumer consumer;

  PaddingModeLiteralInstance() {
    this = any(PaddingMode mode).getAnAccess() and
    consumer = PaddingModeLiteralFlow::getConsumer(this, _, _)
  }

  override string getRawPaddingAlgorithmName() { result = super.getTarget().getName() }

  override Crypto::TPaddingType getPaddingType() {
    if exists(paddingNameToType(this.getRawPaddingAlgorithmName()))
    then result = paddingNameToType(this.getRawPaddingAlgorithmName())
    else result = Crypto::OtherPadding()
  }

  Crypto::AlgorithmValueConsumer getConsumer() { result = consumer }
}

private Crypto::KeyOpAlg::Algorithm symmetricAlgorithmNameToType(string algorithmName) {
  algorithmName = "Aes" and result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES())
  or
  algorithmName = "DES" and result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::DES())
  or
  algorithmName = "RC2" and result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::RC2())
  or
  algorithmName = "Rijndael" and
  result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES())
  or
  algorithmName = "TripleDES" and
  result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::DES())
}

private Crypto::TPaddingType paddingNameToType(string paddingName) {
  paddingName = "ANSIX923" and result = Crypto::ANSI_X9_23()
  or
  paddingName = "None" and result = Crypto::NoPadding()
  or
  paddingName = "PKCS7" and result = Crypto::PKCS7()
}
