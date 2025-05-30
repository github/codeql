import java
import experimental.quantum.Language
import AlgorithmValueConsumers
import FlowAnalysis

/**
 * Elliptic curve algorithms where the curve is implicitly defined by the type.
 */
abstract private class EllipticCurveAlgorithmInstance extends Crypto::EllipticCurveInstance {
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
 * A string literal that represents an elliptic curve name.
 */
class EllipticCurveStringLiteralInstance extends EllipticCurveAlgorithmInstance instanceof StringLiteral
{
  EllipticCurveStringLiteralInstance() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getValue().toUpperCase(), _, _)
  }

  override string getRawEllipticCurveName() { result = super.getValue() }

  EllipticCurveAlgorithmValueConsumer getConsumer() {
    result = EllipticCurveStringLiteralToConsumer::getConsumerFromLiteral(this, _, _)
  }
}

/**
 * Signature algorithms where the algorithm is implicitly defined by the type.
 */
abstract class SignatureAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance,
  SignatureAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  // TODO: Could potentially be used to model signature modes like Ed25519ph and Ed25519ctx.
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

  Crypto::ConsumerInputDataFlowNode getAParametersConsumer() { none() }
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

abstract private class EllipticCurveSignatureAlgorithmInstance extends SignatureAlgorithmInstance,
  EllipticCurveAlgorithmInstance
{
  override Crypto::EllipticCurveInstance getEllipticCurve() { result = this }
}

/**
 * Ed25519, Ed25519ph, and Ed25519ctx signers.
 */
class Ed25519SignatureAlgorithmInstance extends EllipticCurveSignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed25519SignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("Ed25519%")
  }

  override string getRawEllipticCurveName() { result = "CURVE25519" }
}

/**
 * Ed448 and Ed448ph signers.
 */
class Ed448SignatureAlgorithmInstance extends EllipticCurveSignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed448SignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("Ed448%")
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }

  override string getRawEllipticCurveName() { result = "CURVE448" }
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
 *
 * NOTE: This type does not inherit from `EllipticCurveSignatureAlgorithmInstance` because the curve
 * is not implicitly defined by the type, but rather by the key parameters passed to `init()`.
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

/**
 * Key generation algorithms where the algorithm is implicitly defined by the type.
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

  Crypto::ConsumerInputDataFlowNode getAParametersConsumer() { none() }
}

/**
 * Key generation algorithms for elliptic curves where the curve is implicitly defined by the type.
 */
abstract private class EllipticCurveKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance,
  EllipticCurveAlgorithmInstance
{ }

class Ed25519KeyGenerationAlgorithmInstance extends EllipticCurveKeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed25519KeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("Ed25519%")
  }

  override string getRawEllipticCurveName() { result = "Curve25519" }
}

class Ed448KeyGenerationAlgorithmInstance extends EllipticCurveKeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed448KeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("Ed448%")
  }

  override string getRawEllipticCurveName() { result = "Curve25519" }
}

/**
 * Represents a generic `ECKeyPairGenerator` instances.
 *
 * NOTE: This type does not inherit from `EllipticCurveKeyGenerationAlgorithmInstance` because the curve
 * is not implicitly defined by the type, but rather by parameters passed to the constructor.
 */
class GenericEllipticCurveKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  GenericEllipticCurveKeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("EC%")
  }

  override string getRawAlgorithmName() {
    // The generator constructs an elliptic curve key pair, but the algorithm is
    // not determined at key generation. As an example, the key could be used
    // for either ECDSA or ECDH For this reason, we just return "EllipticCurve".
    result = "EllipticCurve"
  }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    // The algorithm type is not known. See above.
    result = Crypto::KeyOpAlg::TUnknownKeyOperationAlgorithmType()
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
