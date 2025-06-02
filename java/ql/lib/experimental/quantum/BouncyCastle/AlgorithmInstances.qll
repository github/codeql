import java
import experimental.quantum.Language
import AlgorithmValueConsumers
import FlowAnalysis

/**
 * Elliptic curve algorithms.
 */
abstract private class EllipticCurveConsumingAlgorithmInstance extends Crypto::EllipticCurveConsumingAlgorithmInstance
{
  string getFixedEllipticCurveName() { none() }

  override Crypto::AlgorithmValueConsumer getEllipticCurveConsumer() {
    result.(ImplicitEllipticCurveInstance).getAlgorithm() = this
  }
}

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
 * Represents an elliptic curve that is implicitly defined by the underlying
 * algorithm. In this case, we view the algorithm and elliptic curve as being
 * implicitly defined by the constructor call.
 */
class ImplicitEllipticCurveInstance extends Crypto::EllipticCurveInstance,
  EllipticCurveAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  EllipticCurveConsumingAlgorithmInstance algorithm;

  ImplicitEllipticCurveInstance() {
    this = algorithm and
    exists(algorithm.getFixedEllipticCurveName())
  }

  EllipticCurveConsumingAlgorithmInstance getAlgorithm() { result = this }

  override string getRawEllipticCurveName() { result = algorithm.getFixedEllipticCurveName() }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

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
class Ed25519SignatureAlgorithmInstance extends SignatureAlgorithmInstance,
  EllipticCurveConsumingAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed25519SignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("Ed25519%")
  }

  override string getFixedEllipticCurveName() { result = "Curve25519" }
}

/**
 * Ed448 and Ed448ph signers.
 */
class Ed448SignatureAlgorithmInstance extends SignatureAlgorithmInstance,
  EllipticCurveConsumingAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed448SignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("Ed448%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }

  override string getFixedEllipticCurveName() { result = "Curve448" }
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
    super.getConstructedType() instanceof Signers::Signer and
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

class Ed25519KeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance,
  EllipticCurveConsumingAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed25519KeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("Ed25519%")
  }

  override string getFixedEllipticCurveName() { result = "Curve25519" }
}

class Ed448KeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance,
  EllipticCurveConsumingAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed448KeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("Ed448%")
  }

  override string getFixedEllipticCurveName() { result = "Curve448" }
}

/**
 * Represents a generic `ECKeyPairGenerator` instance.
 */
class GenericEllipticCurveKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  GenericEllipticCurveKeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("EC%")
  }

  override string getRawAlgorithmName() {
    // TODO: The generator constructs an elliptic curve key pair, but the
    // algorithm is not determined at key generation. As an example, the key
    // could be used for either ECDSA or ECDH. For this reason, we just return
    // "EllipticCurve".
    result = "EllipticCurve"
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    // The algorithm type is not known. See above.
    result = Crypto::KeyOpAlg::TUnknownKeyOperationAlgorithmType()
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
