private import csharp
private import experimental.quantum.Language
private import AlgorithmInstances
private import OperationInstances
private import Cryptography

class EcdsaAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  ECDsaCreateCall call;

  EcdsaAlgorithmValueConsumer() { this = call.getAlgorithmArg() }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(EcdsaAlgorithmInstance l | l.getConsumer() = this and result = l)
  }
}

class HashAlgorithmNameConsumer extends Crypto::AlgorithmValueConsumer {
  HashAlgorithmNameUser call;

  HashAlgorithmNameConsumer() { this = call.getHashAlgorithmNameUser() }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(HashAlgorithmNameInstance l | l.getConsumer() = this and result = l)
  }
}

/**
 * A write access to the `Padding` property of a `SymmetricAlgorithm` instance.
 */
class PaddingPropertyWrite extends Crypto::AlgorithmValueConsumer instanceof SymmetricAlgorithmUse {
  PaddingPropertyWrite() { super.isPaddingConsumer() }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(PaddingModeLiteralInstance).getConsumer() = this
  }
}

/**
 * A write access to the `Mode` property of a `SymmetricAlgorithm` instance.
 */
class CipherModePropertyWrite extends Crypto::AlgorithmValueConsumer instanceof SymmetricAlgorithmUse
{
  CipherModePropertyWrite() { super.isModeConsumer() }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(CipherModeLiteralInstance).getConsumer() = this
  }
}

/**
 * A call to a `SymmetricAlgorithm.CreateEncryptor` or `SymmetricAlgorithm.CreateDecryptor`
 * method that returns a `CryptoTransform` instance.
 */
class SymmetricAlgorithmConsumer extends Crypto::AlgorithmValueConsumer instanceof CryptoTransformCreation
{
  override Crypto::ConsumerInputDataFlowNode getInputNode() {
    result.asExpr() = super.getQualifier()
  }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(SymmetricAlgorithmInstance).getConsumer() = this
  }
}

/**
 * A call to either `Encrypt` or `Decrypt` on an `AesGcm` or `AesCcm` instance.
 * The algorithm is defined implicitly by this AST node.
 */
class AesModeAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer instanceof AesModeUse {
  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }
}
