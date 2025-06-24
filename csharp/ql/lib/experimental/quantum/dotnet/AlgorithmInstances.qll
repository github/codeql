private import csharp
private import experimental.quantum.Language
private import AlgorithmValueConsumers
private import OperationInstances
private import Cryptography
private import FlowAnalysis

class NamedCurveAlgorithmInstance extends Crypto::EllipticCurveInstance instanceof NamedCurvePropertyAccess
{
  NamedCurveAlgorithmInstance() { this instanceof NamedCurvePropertyAccess }

  override string getRawEllipticCurveName() { result = super.getCurveName() }

  override Crypto::TEllipticCurveType getEllipticCurveType() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName(), _, result)
  }

  override int getKeySize() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName(), result, _)
  }
}

abstract class SigningAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance {
  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }


  override int getKeySizeFixed() { none() }
}

class EcdsaAlgorithmInstance extends SigningAlgorithmInstance instanceof SigningCreateCall {
  EcdsaAlgorithmInstance() { this instanceof ECDsaCreateCall }

  EcdsaAlgorithmValueConsumer getConsumer() { result = super.getQualifier() }

  override string getRawAlgorithmName() { result = "ECDsa" }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::ECDSA())
  }
}

class RsaAlgorithmInstance extends SigningAlgorithmInstance {
  RsaAlgorithmInstance() { this = any(RSACreateCall c).getQualifier() }

  override string getRawAlgorithmName() { result = "RSA" }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    // TODO there is no RSA TSignature type, so we use OtherSignatureAlgorithmType
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::OtherSignatureAlgorithmType())
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
  SymmetricAlgorithmConsumer consumer;

  SymmetricAlgorithmInstance() { consumer = SymmetricAlgorithmFlow::getUseFromCreation(this, _, _) }

  override string getRawAlgorithmName() { result = super.getSymmetricAlgorithm().getName() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    if exists(symmetricAlgorithmNameToType(this.getRawAlgorithmName()))
    then result = symmetricAlgorithmNameToType(this.getRawAlgorithmName())
    else result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::OtherSymmetricCipherType())
  }

  // The cipher mode is set by assigning it to the `Mode` property of the
  // symmetric algorithm.
  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() {
    result.(CipherModeLiteralInstance).getConsumer() = this.getCipherModeAlgorithmValueConsumer()
  }

  // The padding mode is set by assigning it to the `Padding` property of the
  // symmetric algorithm.
  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() {
    result.(PaddingModeLiteralInstance).getConsumer() = this.getPaddingAlgorithmValueConsumer()
  }

  Crypto::AlgorithmValueConsumer getPaddingAlgorithmValueConsumer() {
    result = SymmetricAlgorithmFlow::getUseFromCreation(this, _, _) and
    result instanceof PaddingPropertyWrite
  }

  Crypto::AlgorithmValueConsumer getCipherModeAlgorithmValueConsumer() {
    result = SymmetricAlgorithmFlow::getUseFromCreation(this, _, _) and
    result instanceof CipherModePropertyWrite
  }

  override int getKeySizeFixed() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  Crypto::AlgorithmValueConsumer getConsumer() { result = consumer }
}

/**
 * A padding mode literal, such as `PaddingMode.PKCS7`.
 */
class PaddingModeLiteralInstance extends Crypto::PaddingAlgorithmInstance instanceof MemberConstantAccess
{
  Crypto::AlgorithmValueConsumer consumer;

  PaddingModeLiteralInstance() {
    this = any(PaddingMode mode).getAnAccess() and
    consumer = ModeLiteralFlow::getConsumer(this, _, _)
  }

  override string getRawPaddingAlgorithmName() { result = super.getTarget().getName() }

  override Crypto::TPaddingType getPaddingType() {
    if exists(paddingNameToType(this.getRawPaddingAlgorithmName()))
    then result = paddingNameToType(this.getRawPaddingAlgorithmName())
    else result = Crypto::OtherPadding()
  }

  Crypto::AlgorithmValueConsumer getConsumer() { result = consumer }
}

/**
 * A padding mode literal, such as `PaddingMode.PKCS7`.
 */
class CipherModeLiteralInstance extends Crypto::ModeOfOperationAlgorithmInstance instanceof MemberConstantAccess
{
  Crypto::AlgorithmValueConsumer consumer;

  CipherModeLiteralInstance() {
    this = any(CipherMode mode).getAnAccess() and
    consumer = ModeLiteralFlow::getConsumer(this, _, _)
  }

  override string getRawModeAlgorithmName() { result = super.getTarget().getName() }

  override Crypto::TBlockCipherModeOfOperationType getModeType() {
    if exists(modeNameToType(this.getRawModeAlgorithmName()))
    then result = modeNameToType(this.getRawModeAlgorithmName())
    else result = Crypto::OtherMode()
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

private Crypto::TBlockCipherModeOfOperationType modeNameToType(string modeName) {
  modeName = "CBC" and result = Crypto::CBC()
  or
  modeName = "CFB" and result = Crypto::CFB()
  or
  modeName = "ECB" and result = Crypto::ECB()
  or
  modeName = "OFB" and result = Crypto::OFB()
}
