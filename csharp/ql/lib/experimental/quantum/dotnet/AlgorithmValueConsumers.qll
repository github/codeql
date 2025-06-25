private import csharp
private import experimental.quantum.Language
private import AlgorithmInstances
private import OperationInstances
private import Cryptography

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
