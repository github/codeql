private import csharp
private import experimental.quantum.Language
private import AlgorithmInstances
private import Cryptography

class ECDsaAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  ECDsaCreateCall call;

  ECDsaAlgorithmValueConsumer() { this = call.getAlgorithmArg() }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(SigningNamedCurveAlgorithmInstance l | l.getConsumer() = this and result = l)
  }
}
