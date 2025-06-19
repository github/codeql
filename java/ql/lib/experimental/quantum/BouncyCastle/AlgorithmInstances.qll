private import java
private import experimental.quantum.Language
private import AlgorithmValueConsumers
private import OperationInstances
private import FlowAnalysis

/**
 * A string literal that represents an elliptic curve name.
 */
class EllipticCurveStringLiteralInstance extends Crypto::EllipticCurveInstance instanceof StringLiteral
{
  EllipticCurveStringLiteralInstance() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(super.getValue().toUpperCase(), _, _)
  }

  override string getRawEllipticCurveName() { result = super.getValue() }

  Crypto::AlgorithmValueConsumer getConsumer() {
    result = EllipticCurveStringLiteralToConsumerFlow::getConsumerFromLiteral(this, _, _)
  }

  override Crypto::TEllipticCurveType getEllipticCurveType() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName().toUpperCase(),
      _, result)
  }

  override int getKeySize() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName().toUpperCase(),
      result, _)
  }
}

/**
 * A signature algorithm instance where the algorithm is implicitly defined by
 * the constructed type.
 */
class ImplicitSignatureClassInstanceExpr extends Crypto::KeyOperationAlgorithmInstance,
  ImplicitAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  ImplicitSignatureClassInstanceExpr() { super.getConstructedType() instanceof Signers::Signer }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    signatureNameToAlgorithmMapping(this.getRawAlgorithmName(), result)
  }

  override int getKeySizeFixed() {
    signatureNameToKeySizeMapping(this.getRawAlgorithmName(), result)
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getConstructedType().getName(), result)
  }

  // Used for data flow from elliptic curve string literals to the algorithm
  // instance.
  DataFlow::Node getParametersInput() { none() }

  // Used for data flow from elliptic curve string literals to the algorithm
  // instance.
  DataFlow::Node getEllipticCurveInput() { none() }
}

/**
 * A key generation algorithm instance where algorithm is a key operation (e.g.
 * a signature algorithm) implicitly defined by the constructed type.
 */
class ImplicitKeyGenerationClassInstanceExpr extends Crypto::KeyOperationAlgorithmInstance,
  ImplicitAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  ImplicitKeyGenerationClassInstanceExpr() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches(["Ed25519%", "Ed448%", "LMS%", "HSS%"])
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getConstructedType().getName(), result)
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    generatorNameToAlgorithmMapping(this.getRawAlgorithmName(), result)
  }

  override int getKeySizeFixed() {
    generatorNameToKeySizeMapping(this.getRawAlgorithmName(), result)
  }

  // Used for data flow from elliptic curve string literals to the algorithm
  // instance.
  DataFlow::Node getParametersInput() { none() }

  // Used for data flow from elliptic curve string literals to the algorithm
  // instance.
  DataFlow::Node getEllipticCurveInput() { none() }
}

/**
 * A block cipher used in a mode of operation. The algorithm is implicitly
 * defined by the type.
 */
class BlockCipherAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance instanceof ClassInstanceExpr
{
  // We track the block cipher mode here to ensure that going from the block
  // cipher instance to the block cipher mode instance and back always yields
  // the same instance.
  //
  // Since the block cipher algorithm instance is always resolved using data
  // flow from the block cipher mode, we don't loose any information by
  // requiring that this flow exists.
  BlockCipherModeAlgorithmInstance mode;

  BlockCipherAlgorithmInstance() {
    super.getConstructedType() instanceof Modes::BlockCipher and
    mode = BlockCipherToBlockCipherModeFlow::getBlockCipherModeFromBlockCipher(this, _, _)
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    if blockCipherNameToAlgorithmMapping(this.getRawAlgorithmName(), _)
    then blockCipherNameToAlgorithmMapping(this.getRawAlgorithmName(), result)
    else result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::OtherSymmetricCipherType())
  }

  // TODO: Implement this.
  override int getKeySizeFixed() { none() }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getType().getName(), result)
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { result = mode }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() {
    result = BlockCipherToPaddingModeFlow::getPaddingModeFromBlockCipher(this)
  }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  // Gets a consumer of this block cipher algorithm instance.
  Crypto::AlgorithmValueConsumer getConsumer() { result = mode.getBlockCipherArg() }
}

/**
 * A block cipher mode instance.
 */
class BlockCipherModeAlgorithmInstance extends Crypto::ModeOfOperationAlgorithmInstance,
  ImplicitAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  BlockCipherModeAlgorithmInstance() {
    super.getConstructedType() instanceof Modes::UnpaddedBlockCipherMode
  }

  override string getRawModeAlgorithmName() {
    result = super.getConstructedType().getName().splitAt("BlockCipher", 0)
  }

  override Crypto::TBlockCipherModeOfOperationType getModeType() {
    if modeNameToModeTypeMapping(this.getRawModeAlgorithmName(), _)
    then modeNameToModeTypeMapping(this.getRawModeAlgorithmName(), result)
    else result = Crypto::OtherMode()
  }

  Expr getBlockCipherArg() {
    exists(Expr arg |
      arg = super.getAnArgument() and
      arg.getType() instanceof Modes::BlockCipher and
      result = arg
    )
  }

  Crypto::AlgorithmValueConsumer getConsumer() { result = this }
}

/**
 * A padding mode instance implicitly determined by the constructor.
 */
class PaddingAlgorithmInstance extends Crypto::PaddingAlgorithmInstance instanceof ClassInstanceExpr
{
  PaddingAlgorithmInstance() { super.getConstructedType() instanceof Modes::PaddingMode }

  override Crypto::TPaddingType getPaddingType() {
    paddingNameToTypeMapping(this.getRawPaddingAlgorithmName(), result)
  }

  override string getRawPaddingAlgorithmName() {
    result = super.getConstructedType().getName().splitAt("Padding", 0)
  }
}

/**
 * Private predicates mapping type names to raw names, key sizes and algorithms.
 */
bindingset[typeName]
private predicate typeNameToRawAlgorithmNameMapping(string typeName, string algorithmName) {
  // Ed25519, Ed25519ph, and Ed25519ctx key generators and signers
  typeName.matches("Ed25519%") and
  algorithmName = "Ed25519"
  or
  // Ed448 and Ed448ph key generators and signers
  typeName.matches("Ed448%") and
  algorithmName = "Ed448"
  or
  // ECDSA
  typeName.matches("ECDSA%") and
  algorithmName = "ECDSA"
  or
  // DSA
  typeName.matches("DSA%") and
  algorithmName = "DSA"
  or
  // LMS
  typeName.matches("LMS%") and
  algorithmName = "LMS"
  or
  // HSS
  typeName.matches("HSS%") and
  algorithmName = "HSS"
  or
  typeName.matches("AES%") and
  algorithmName = "AES"
  or
  typeName.matches("Aria%") and
  algorithmName = "Aria"
  or
  typeName.matches("Blowfish%") and
  algorithmName = "Blowfish"
  or
  typeName.matches("DES%") and
  algorithmName = "DES"
  or
  typeName.matches("TripleDES%") and
  algorithmName = "TripleDES"
}

private predicate modeNameToModeTypeMapping(
  string modeName, Crypto::TBlockCipherModeOfOperationType modeType
) {
  modeName = "CBC" and
  modeType = Crypto::CBC()
  or
  modeName = "CCM" and
  modeType = Crypto::CCM()
  or
  modeName = "CFB" and
  modeType = Crypto::CFB()
  or
  modeName = "CTR" and
  modeType = Crypto::CTR()
  or
  modeName = "ECB" and
  modeType = Crypto::ECB()
  or
  modeName = "GCM" and
  modeType = Crypto::GCM()
  or
  modeName = "OCB" and
  modeType = Crypto::OCB()
  or
  modeName = "OFB" and
  modeType = Crypto::OFB()
  or
  modeName = "XTS" and
  modeType = Crypto::XTS()
}

private predicate paddingNameToTypeMapping(string paddingName, Crypto::TPaddingType paddingType) {
  paddingName = "NoPadding" and
  paddingType = Crypto::NoPadding()
  or
  paddingName = "PKCS7" and
  paddingType = Crypto::PKCS7()
  or
  paddingName = "ISO10126" and
  paddingType = Crypto::OtherPadding()
  or
  paddingName = "ZeroByte" and
  paddingType = Crypto::OtherPadding()
}

private predicate signatureNameToAlgorithmMapping(
  string signatureName, Crypto::KeyOpAlg::Algorithm algorithmType
) {
  signatureName = "Ed25519" and
  algorithmType = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  signatureName = "Ed448" and
  algorithmType = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
  or
  signatureName = "ECDSA" and
  algorithmType = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::ECDSA())
  or
  signatureName = "LMS" and
  algorithmType = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::LMS())
  or
  signatureName = "HSS" and
  algorithmType = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::HSS())
}

private predicate signatureNameToKeySizeMapping(string signatureName, int keySize) {
  signatureName = "Ed25519" and
  keySize = 256
  or
  signatureName = "Ed448" and
  keySize = 448
}

private predicate generatorNameToAlgorithmMapping(
  string generatorName, Crypto::KeyOpAlg::Algorithm algorithmType
) {
  generatorName = "Ed25519" and
  algorithmType = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  generatorName = "Ed448" and
  algorithmType = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
  or
  generatorName = "LMS" and
  algorithmType = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::LMS())
  or
  generatorName = "HSS" and
  algorithmType = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::HSS())
}

private predicate generatorNameToKeySizeMapping(string generatorName, int keySize) {
  generatorName = "Ed25519" and
  keySize = 256
  or
  generatorName = "Ed448" and
  keySize = 448
}

private predicate blockCipherNameToAlgorithmMapping(
  string cipherName, Crypto::KeyOpAlg::Algorithm algorithmType
) {
  cipherName = "AES" and
  algorithmType = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES())
  or
  cipherName = "Aria" and
  algorithmType = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::ARIA())
  or
  cipherName = "Blowfish" and
  algorithmType = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::BLOWFISH())
  or
  cipherName = "DES" and
  algorithmType = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::DES())
  or
  cipherName = "TripleDES" and
  algorithmType = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::TripleDES())
}
