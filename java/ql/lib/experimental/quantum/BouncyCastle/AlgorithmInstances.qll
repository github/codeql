import java
import experimental.quantum.Language
import AlgorithmValueConsumers

abstract private class EllipticCurveAlgorithmInstance extends Crypto::EllipticCurveInstance,
  EllipticCurveAlgorithmValueConsumer
{
  override Crypto::TEllipticCurveType getEllipticCurveType() {
    Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName(), _, result)
  }

  override string getKeySize() {
    exists(int keySize |
      Crypto::ellipticCurveNameToKeySizeAndFamilyMapping(this.getRawEllipticCurveName(), keySize, _) and
      result = keySize.toString()
    )
  }
}

/**
 * Signature algorithms.
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

  override string getKeySizeFixed() {
    signatureNameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), result, _)
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }
}

abstract private class EllipticCurveSignatureAlgorithmInstance extends SignatureAlgorithmInstance,
  EllipticCurveAlgorithmInstance
{ }

class Ed25519SignatureAlgorithmInstance extends EllipticCurveSignatureAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed25519SignatureAlgorithmInstance() {
    super.getConstructedType() instanceof Signers::Signer and
    super.getConstructedType().getName().matches("Ed25519%")
  }

  override string getRawEllipticCurveName() { result = "CURVE25519" }
}

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
 * Key generation algorithms.
 */
abstract class KeyGenerationAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance,
  KeyGenerationAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  // TODO: Model flow from the parameter specification to the key generator.
  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    generatorNameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), _, result)
  }

  override string getKeySizeFixed() {
    generatorNameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), result, _)
  }

  override string getRawAlgorithmName() {
    typeNameToRawAlgorithmName(super.getConstructedType().getName(), result)
  }
}

abstract private class EllipticCurveKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance,
  EllipticCurveAlgorithmInstance
{ }

class Ed25519KeyGenerationAlgorithmInstance extends EllipticCurveKeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed25519KeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("Ed25519%")
  }

  override string getRawEllipticCurveName() { result = "CURVE25519" }
}

class Ed448KeyGenerationAlgorithmInstance extends EllipticCurveKeyGenerationAlgorithmInstance instanceof ClassInstanceExpr
{
  Ed448KeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator and
    super.getConstructedType().getName().matches("Ed448%")
  }

  override string getRawEllipticCurveName() { result = "CURVE25519" }
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
}

private predicate signatureNameToKeySizeAndAlgorithmMapping(
  string name, string keySize, Crypto::KeyOpAlg::Algorithm algorithm
) {
  name = "ED25519" and
  keySize = "256" and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  name = "ED448" and
  keySize = "448" and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
}

private predicate generatorNameToKeySizeAndAlgorithmMapping(
  string name, string keySize, Crypto::KeyOpAlg::Algorithm algorithm
) {
  name = "ED25519" and
  keySize = "256" and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  name = "ED448" and
  keySize = "448" and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
}
