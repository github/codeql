private import csharp
private import experimental.quantum.Language
private import AlgorithmInstances
private import OperationInstances
private import Cryptography

class ECDsaAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  ECDsaCreateCall call;

  ECDsaAlgorithmValueConsumer() { this = call.getAlgorithmArg() }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(NamedCurveAlgorithmInstance l | l.getConsumer() = this and result = l)
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
