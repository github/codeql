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
 * A padding mode argument passed to a symmetric algorithm method call.
 */
class PaddingModeArgument extends Crypto::AlgorithmValueConsumer instanceof Expr {
  SymmetricAlgorithmUse use;

  PaddingModeArgument() {
    (use.isEncryptionCall() or use.isDecryptionCall()) and
    this = use.getPaddingArg()
  }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(PaddingModeLiteralInstance).getConsumer() = this
  }
}

/**
 * A qualified expression where the qualifier is a `SymmetricAlgorithm`
 * instance. (e.g. a call to `SymmetricAlgorithm.EncryptCbc` or
 * `SymmetricAlgorithm.CreateEncryptor`)
 */
class SymmetricAlgorithmConsumer extends Crypto::AlgorithmValueConsumer instanceof SymmetricAlgorithmUse
{
  SymmetricAlgorithmConsumer() {
    super.isEncryptionCall() or super.isDecryptionCall() or super.isCreationCall()
  }

  override Crypto::ConsumerInputDataFlowNode getInputNode() {
    result.asExpr() = super.getQualifier()
  }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }
}

/**
 * A call to either `Encrypt` or `Decrypt` on an `AesGcm`, `AesCcm` or
 * `ChaCha20Poly1305` instance.  The algorithm is defined implicitly by this AST
 * node.
 */
class AeadAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer instanceof AeadUse {
  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    // See `AeadAlgorithmInstance` for the algorithm instance.
    result = this
  }
}
