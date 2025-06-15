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
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getValue().toUpperCase(), _, _)
  }

  override string getRawEllipticCurveName() { result = super.getValue() }

  EllipticCurveAlgorithmValueConsumer getConsumer() {
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
 * An elliptic curve algorithm where the elliptic curve is implicitly defined by
 * the underlying type.
 */
abstract class KnownEllipticCurveInstance extends Crypto::EllipticCurveInstance,
  Crypto::EllipticCurveConsumingAlgorithmInstance, Crypto::AlgorithmValueConsumer instanceof ClassInstanceExpr
{
  override Crypto::TEllipticCurveType getEllipticCurveType() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName().toUpperCase(),
      _, result)
  }

  override int getKeySize() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName().toUpperCase(),
      result, _)
  }

  override Crypto::AlgorithmValueConsumer getEllipticCurveConsumer() { result = this }
}

/**
 * A signature algorithm where the algorithm is implicitly defined by the type.
 */
abstract class SignatureAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance,
  SignatureAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    signatureNameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), _, result)
  }

  override int getKeySizeFixed() {
    signatureNameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), result, _)
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getConstructedType().getName(), result)
  }

  // Used for data flow from elliptic curve string literals to the algorithm
  DataFlow::Node getParametersInput() { none() }

  // Used for data flow from elliptic curve string literals to the algorithm
  DataFlow::Node getEllipticCurveInput() { none() }
}

/**
 * An elliptic curve signature algorithm where both the signature algorithm and
 * elliptic curve are implicitly defined by the underlying type.
 */
abstract class KnownEllipticCurveSignatureAlgorithmInstance extends KnownEllipticCurveInstance,
  SignatureAlgorithmInstance
{
  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }
}

/**
 * A DSA or DSADigest signer.
 */
class DsaSignatureAlgorithmInstance extends SignatureAlgorithmInstance instanceof ClassInstanceExpr {
  DsaSignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("DSA%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getConstructedType().getName(), result)
  }
}

/**
 * An Ed25519, Ed25519ph, or Ed25519ctx signer.
 */
class Ed25519SignatureAlgorithmInstance extends KnownEllipticCurveSignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed25519SignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("Ed25519%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getConstructedType().getName(), result)
  }

  override string getRawEllipticCurveName() { result = "Curve25519" }
}

/**
 * An Ed448 or Ed448ph signer.
 */
class Ed448SignatureAlgorithmInstance extends KnownEllipticCurveSignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed448SignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("Ed448%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getConstructedType().getName(), result)
  }

  override string getRawEllipticCurveName() { result = "Curve448" }
}

/**
 * An ECDSA signer.
 *
 * ECDSA curve parameters can be set in at least five ways:
 * - By using the `ECDomainParameters` class, which is passed to the constructor of the signer.
 * - By using the `ECNamedDomainParameters` class, which is passed to the constructor of the signer.
 * - By using the `ECNamedCurveTable` class, which is used to obtain the curve parameters.
 * - By using the `ECNamedCurveSpec` class, which is passed to the constructor of the signer.
 * - By using the `ECParameterSpec` class, which is passed to the constructor of the signer.
 */
class EcdsaSignatureAlgorithmInstance extends SignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  EcdsaSignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::OneShotSigner and
    super.getConstructedType().getName().matches("ECDSA%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getConstructedType().getName(), result)
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::ECDSA())
  }

  override int getKeySizeFixed() { none() }
}

/**
 * An LMS or HSS stateful, hash-based signer.
 */
class StatefulSignatureAlgorithmInstance extends SignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  StatefulSignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches(["LMS%", "HSS%"])
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getConstructedType().getName(), result)
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    super.getConstructedType().getName().matches("LMS%") and
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::LMS())
    or
    super.getConstructedType().getName().matches("HSS%") and
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::HSS())
  }
}

/**
 * A key generation algorithm where the algorithm is implicitly defined by the
 * type.
 */
abstract class KeyGenerationAlgorithmInstance extends Crypto::AlgorithmInstance,
  KeyGenerationAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  // Used for data flow from elliptic curve string literals to the algorithm
  // instance.
  DataFlow::Node getParametersInput() { none() }

  // Used for data flow from elliptic curve string literals to the algorithm
  // instance.
  DataFlow::Node getEllipticCurveInput() { none() }

  string getRawAlgorithmName() {
    typeNameToRawAlgorithmNameMapping(super.getConstructedType().getName(), result)
  }

  int getKeySizeFixed() {
    generatorNameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), result, _)
  }
}

/**
 * An elliptic curve key generation algorithm where both the key generation
 * algorithm and elliptic curve are implicitly defined by the underlying type.
 */
abstract class KnownEllipticCurveKeyGenerationAlgorithmInstance extends KnownEllipticCurveInstance,
  KeyGenerationAlgorithmInstance
{
  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }
}

class Ed25519KeyGenerationAlgorithmInstance extends KnownEllipticCurveKeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed25519KeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("Ed25519%")
  }

  override string getRawEllipticCurveName() { result = "Curve25519" }
}

class Ed448KeyGenerationAlgorithmInstance extends KnownEllipticCurveKeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed448KeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("Ed448%")
  }

  override string getRawEllipticCurveName() { result = "Curve448" }
}

/**
 * A generic `ECKeyPairGenerator` instance.
 */
class GenericEllipticCurveKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance,
  Crypto::EllipticCurveConsumingAlgorithmInstance instanceof ClassInstanceExpr
{
  GenericEllipticCurveKeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("EC%")
  }

  override Crypto::AlgorithmValueConsumer getEllipticCurveConsumer() {
    // The elliptic curve is resolved recursively from the parameters passed to
    // the `init()` call.
    exists(MethodCall init |
      init = Generators::KeyGeneratorFlow::getInitFromNew(this, _, _) and
      result =
        Generators::ParametersFlow::getParametersFromInit(init, _, _).getAnAlgorithmValueConsumer()
    )
  }

  Crypto::EllipticCurveInstance getConsumedEllipticCurve() {
    result = this.getEllipticCurveConsumer().getAKnownAlgorithmSource()
  }
}

/**
 * An LMS or HSS key generation instances. The algorithm is implicitly defined
 * by the type.
 */
class StatefulSignatureKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  StatefulSignatureKeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches(["LMS%", "HSS%"])
  }
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
  BlockCipherModeAlgorithmValueConsumer instanceof ClassInstanceExpr
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

private predicate signatureNameToKeySizeAndAlgorithmMapping(
  string name, int keySize, Crypto::KeyOpAlg::Algorithm algorithm
) {
  name = "Ed25519" and
  keySize = 256 and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  name = "Ed448" and
  keySize = 448 and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
}

private predicate generatorNameToKeySizeAndAlgorithmMapping(
  string name, int keySize, Crypto::KeyOpAlg::Algorithm algorithm
) {
  name = "Ed25519" and
  keySize = 256 and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  name = "Ed448" and
  keySize = 448 and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
}

private predicate blockCipherNameToAlgorithmMapping(
  string name, Crypto::KeyOpAlg::Algorithm algorithm
) {
  name = "AES" and
  algorithm = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::AES())
  or
  name = "Aria" and
  algorithm = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::ARIA())
  or
  name = "Blowfish" and
  algorithm = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::BLOWFISH())
  or
  name = "DES" and
  algorithm = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::DES())
  or
  name = "TripleDES" and
  algorithm = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::TripleDES())
}
