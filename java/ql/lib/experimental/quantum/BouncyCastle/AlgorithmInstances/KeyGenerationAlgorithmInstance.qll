import java
import experimental.quantum.Language

/**
 * Key generation algorithms are implicitly defined by the constructor.
 */
abstract private class KeyGenerationAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

class KeyGenerationAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance,
  KeyGenerationAlgorithmValueConsumer instanceof ClassInstanceExpr
{
  KeyGenerationAlgorithmInstance() {
    super.getConstructedType() instanceof Generators::KeyGenerator
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    nameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), _, result)
  }

  override string getKeySizeFixed() {
    nameToKeySizeAndAlgorithmMapping(this.getRawAlgorithmName(), result, _)
  }

  override string getRawAlgorithmName() {
    result = super.getConstructedType().(Generators::KeyGenerator).getRawAlgorithmName()
  }

  // This is overridden if a specific generator type has a key size consumer.
  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }
}

class CramerShoupKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance {
  CramerShoupKeyGenerationAlgorithmInstance() { super.getRawAlgorithmName() = "CramerShoup" }

  override string getKeySizeFixed() { none() }

  // TODO: Model flow from the `CramerShoupParametersGenerator::init` method
  // (which takes a size of the prime order group in bits), via the
  // `CramerShoupParameters` object, to the key-pair generator.
  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    result = Crypto::KeyOpAlg::TAsymmetricCipher(Crypto::KeyOpAlg::OtherAsymmetricCipherType())
  }
}

class DESedeKeyGenerationAlgorithmInstance extends KeyGenerationAlgorithmInstance {
  DESedeKeyGenerationAlgorithmInstance() { super.getRawAlgorithmName() = "DESede" }

  // Key size is 112 or 168 bits.
  override string getKeySizeFixed() { none() }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    result = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::TripleDES())
  }
}

private predicate nameToKeySizeAndAlgorithmMapping(
  string name, string keySize, Crypto::KeyOpAlg::Algorithm algorithm
) {
  // DES
  name = "DES" and
  keySize = "56" and
  algorithm = Crypto::KeyOpAlg::TSymmetricCipher(Crypto::KeyOpAlg::DES())
  or
  // Ed25519, Ed25519ph, and Ed25519ctx
  name = "Ed25519" and
  keySize = "256" and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  // Ed448 and Ed448ph
  name = "Ed448" and
  keySize = "448" and
  algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
}
