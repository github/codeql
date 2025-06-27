import cpp
private import experimental.quantum.Language
private import semmle.code.cpp.dataflow.new.DataFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstances

abstract class KemAlgorithmValueConsumer extends OpenSslAlgorithmValueConsumer { }

class EvpKemAlgorithmValueConsumer extends KemAlgorithmValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EvpKemAlgorithmValueConsumer() {
    resultNode.asExpr() = this and
    (
      this.(Call).getTarget().getName() = "EVP_KEM_fetch" and
      valueArgNode.asExpr() = this.(Call).getArgument(1)
    )
  }

  override DataFlow::Node getResultNode() { result = resultNode }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result = valueArgNode }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSslAlgorithmInstance i | i.getAvc() = this and result = i)
  }
}
