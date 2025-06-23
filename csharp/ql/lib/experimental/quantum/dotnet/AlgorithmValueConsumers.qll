private import csharp
private import experimental.quantum.Language
private import AlgorithmInstances
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
