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

/**
 * A call to an encryption, decryption, or transform creation API (e.g.
 * `EncryptCbc` or `CreateEncryptor`) on a `SymmetricAlgorithm` instance.
 */
class SymmetricAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance instanceof SymmetricAlgorithmUse
{
  SymmetricAlgorithmInstance() {
    this.isEncryptionCall() or this.isDecryptionCall() or this.isCreationCall()
  }

  override string getRawAlgorithmName() {
    result = super.getSymmetricAlgorithm().getType().getName()
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    if exists(symmetricAlgorithmNameToType(this.getRawAlgorithmName()))
    then result = symmetricAlgorithmNameToType(this.getRawAlgorithmName())
    else result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::OtherSymmetricCipherType())
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() {
    super.isCreationCall() and
    result.(CipherModeLiteralInstance).getConsumer() = this.getCipherModeAlgorithmValueConsumer()
    or
    (super.isEncryptionCall() or super.isDecryptionCall()) and
    result = this
  }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() {
    result.(PaddingModeLiteralInstance).getConsumer() = this.getPaddingAlgorithmValueConsumer()
  }

  // The padding mode is set by assigning it to the `Padding` property of the
  // symmetric algorithm. It can also be passed as an argument to `EncryptCbc`,
  // `EncryptCfb`, etc.
  Crypto::AlgorithmValueConsumer getPaddingAlgorithmValueConsumer() {
    super.isCreationCall() and
    result = SymmetricAlgorithmFlow::getIntermediateUseFromUse(this, _, _) and
    result instanceof PaddingPropertyWrite
    or
    (super.isEncryptionCall() or super.isDecryptionCall()) and
    result = super.getPaddingArg()
  }

  // The cipher mode is set by assigning it to the `Mode` property of the
  // symmetric algorithm, or if this is an encryption/decryption call, it
  // is implicit in the method name.
  Crypto::AlgorithmValueConsumer getCipherModeAlgorithmValueConsumer() {
    result = SymmetricAlgorithmFlow::getIntermediateUseFromUse(this, _, _) and
    result instanceof CipherModePropertyWrite
  }

  override int getKeySizeFixed() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }
}

/**
 * A call to an encryption or decryption API (e.g. `EncryptCbc` or `EncryptCfb`)
 * on a `SymmetricAlgorithm` instance.
 *
 * For these, the cipher mode is given by the method name.
 */
class SymmetricAlgorithmMode extends Crypto::ModeOfOperationAlgorithmInstance instanceof SymmetricAlgorithmUse
{
  SymmetricAlgorithmMode() { this.isEncryptionCall() or this.isDecryptionCall() }

  override string getRawModeAlgorithmName() {
    result = this.(SymmetricAlgorithmUse).getRawModeAlgorithmName()
  }

  override Crypto::TBlockCipherModeOfOperationType getModeType() {
    if exists(modeNameToType(this.getRawModeAlgorithmName().toUpperCase()))
    then result = modeNameToType(this.getRawModeAlgorithmName().toUpperCase())
    else result = Crypto::OtherMode()
  }
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
 * A cipher mode literal, such as `CipherMode.CBC`.
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

/**
 * A call to either `Encrypt` or `Decrypt` on an `AesGcm`, `AesCcm`, or
 * `ChaCha20Poly1305` instance. The algorithm is defined implicitly by this AST
 * node.
 */
class AeadAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance,
  Crypto::ModeOfOperationAlgorithmInstance instanceof AeadUse
{
  override string getRawAlgorithmName() {
    super.getQualifier().getType().hasName("Aes%") and result = "Aes"
    or
    super.getQualifier().getType().hasName("ChaCha20%") and result = "ChaCha20"
  }

  override string getRawModeAlgorithmName() {
    super.getQualifier().getType().getName() = "AesGcm" and result = "Gcm"
    or
    super.getQualifier().getType().getName() = "AesCcm" and result = "Ccm"
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    this.getRawAlgorithmName() = "Aes" and
    result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES())
    or
    this.getRawAlgorithmName() = "ChaCha20" and
    result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::CHACHA20())
  }

  override Crypto::TBlockCipherModeOfOperationType getModeType() {
    this.getRawModeAlgorithmName() = "Gcm" and result = Crypto::GCM()
    or
    this.getRawModeAlgorithmName() = "Ccm" and result = Crypto::CCM()
  }

  override int getKeySizeFixed() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { result = this }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }
}

private Crypto::KeyOpAlg::Algorithm symmetricAlgorithmNameToType(string algorithmName) {
  algorithmName = "Aes%" and result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES())
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
