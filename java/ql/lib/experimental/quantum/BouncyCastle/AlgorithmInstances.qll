import java
import experimental.quantum.Language
import AlgorithmValueConsumers
import OperationInstances
import FlowAnalysis

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
    result = EllipticCurveStringLiteralToConsumer::getConsumerFromLiteral(this, _, _)
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
 * Represents an elliptic curve algorithm where the elliptic curve is implicitly
 * defined by the underlying type.
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
 * Signature algorithms where the algorithm is implicitly defined by the type.
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
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }

  /**
   * Used for data flow from elliptic curve string literals to the algorithm
   * instance.
   */
  DataFlow::Node getParametersInput() { none() }

  /**
   * Used for data flow from elliptic curve string literals to the algorithm
   * instance.
   */
  DataFlow::Node getEllipticCurveInput() { none() }
}

/**
 * Represents an elliptic curve signature algorithm where both the signature
 * algorithm and elliptic curve are implicitly defined by the underlying type.
 */
abstract class KnownEllipticCurveSignatureAlgorithmInstance extends KnownEllipticCurveInstance,
  SignatureAlgorithmInstance
{
  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }
}

/**
 * DSA and DSADigest signers.
 */
class DSASignatureAlgorithmInstance extends SignatureAlgorithmInstance instanceof ClassInstanceExpr {
  DSASignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("DSA%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }
}

/**
 * Ed25519, Ed25519ph, and Ed25519ctx signers.
 */
class Ed25519SignatureAlgorithmInstance extends KnownEllipticCurveSignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed25519SignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("Ed25519%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }

  override string getRawEllipticCurveName() { result = "Curve25519" }
}

/**
 * Ed448 and Ed448ph signers.
 */
class Ed448SignatureAlgorithmInstance extends KnownEllipticCurveSignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed448SignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("Ed448%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }

  override string getRawEllipticCurveName() { result = "Curve448" }
}

/**
 * ECDSA signers.
 *
 * ECDSA curve parameters can be set in at least five ways:
 * - By using the `ECDomainParameters` class, which is passed to the constructor of the signer.
 * - By using the `ECNamedDomainParameters` class, which is passed to the constructor of the signer.
 * - By using the `ECNamedCurveTable` class, which is used to obtain the curve parameters.
 * - By using the `ECNamedCurveSpec` class, which is passed to the constructor of the signer.
 * - By using the `ECParameterSpec` class, which is passed to the constructor of the signer.
 */
class ECDSASignatureAlgorithmInstance extends SignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  ECDSASignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::OneShotSigner and
    super.getConstructedType().getName().matches("ECDSA%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::ECDSA())
  }

  override int getKeySizeFixed() { none() }
}

/**
 * LMS signers.
 */
class LMSSignatureAlgorithmInstance extends SignatureAlgorithmInstance instanceof ClassInstanceExpr {
  LMSSignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("LMS%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::LMS())
  }
}

/**
 * Key generation algorithms where the algorithm is implicitly defined by the
 * type.
 */
abstract class KeyGenerationAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance,
  KeyGenerationAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    generatorNameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), _, result)
  }

  override int getKeySizeFixed() {
    generatorNameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), result, _)
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }

  /**
   * Used for data flow from elliptic curve string literals to the algorithm
   * instance.
   */
  DataFlow::Node getParametersInput() { none() }

  /**
   * Used for data flow from elliptic curve string literals to the algorithm
   * instance.
   */
  DataFlow::Node getEllipticCurveInput() { none() }
}

/**
 * Represents an elliptic curve key generation algorithm where both the key
 * generation algorithm and elliptic curve are implicitly defined by the
 * underlying type.
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
 * Represents a generic `ECKeyPairGenerator` instance.
 */
class GenericEllipticCurveKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance,
  Crypto::EllipticCurveConsumingAlgorithmInstance instanceof ClassInstanceExpr
{
  GenericEllipticCurveKeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("EC%")
  }

  override string getRawAlgorithmName() {
    // TODO: The generator constructs an elliptic curve key pair. The curve used
    // is determined using data flow. If this fails we would like to report
    // something useful, so we use "UnknownCurve". However, this should probably
    // be handled at the node layer.
    if exists(this.getConsumedEllipticCurve())
    then result = this.getConsumedEllipticCurve().getRawEllipticCurveName()
    else result = "UnknownCurve"
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    // TODO: There is currently to algorithm type for elliptic curve key
    // generation.
    result = Crypto::KeyOpAlg::TUnknownKeyOperationAlgorithmType()
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
 * Represents LMS key generation instances. The algorithm is implicitly defined
 * by the type.
 *
 * TODO: Determine how to represent LMS parameters, such as the hash function
 * and the tree height.
 */
class LMSKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  LMSKeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("LMS%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::LMS())
  }
}

/**
 * Private predicates mapping type names to raw names, key sizes and algorithms.
 */
bindingset[typeName]
private predicate typeNameToRawAlgorithmName(string typeName, string algorithmName) {
  // Ed25519, Ed25519ph, and Ed25519ctx key generators and signers
  typeName.matches("Ed25519%") and
  algorithmName = "ED25519"
  or
  // Ed448 and Ed448ph key generators and signers
  typeName.matches("Ed448%") and
  algorithmName = "ED448"
  or
  // ECDSA
  typeName.matches("ECDSA%") and
  algorithmName = "ECDSA"
  or
  // LMS
  typeName.matches("LMS%") and
  algorithmName = "LMS"
}

private predicate signatureNameToKeySizeAndAlgorithmMapping(
  string name, int keySize, Crypto::KeyOpAlg::Algorithm algorithm
) {
  name = "ED25519" and
  keySize = 256 and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  name = "ED448" and
  keySize = 448 and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
}

private predicate generatorNameToKeySizeAndAlgorithmMapping(
  string name, int keySize, Crypto::KeyOpAlg::Algorithm algorithm
) {
  name = "ED25519" and
  keySize = 256 and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  name = "ED448" and
  keySize = 448 and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
}
