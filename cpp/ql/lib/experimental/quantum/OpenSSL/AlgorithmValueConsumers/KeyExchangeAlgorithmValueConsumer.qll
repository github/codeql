import cpp
private import experimental.quantum.Language
private import semmle.code.cpp.dataflow.new.DataFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstances

abstract class KeyExchangeAlgorithmValueConsumer extends OpenSslAlgorithmValueConsumer { }

class EvpKeyExchangeAlgorithmValueConsumer extends KeyExchangeAlgorithmValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EvpKeyExchangeAlgorithmValueConsumer() {
    resultNode.asExpr() = this and
    (
      this.(Call).getTarget().getName() = "EVP_KEYEXCH_fetch" and
      valueArgNode.asExpr() = this.(Call).getArgument(1)
    )
  }

  override DataFlow::Node getResultNode() { result = resultNode }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result = valueArgNode }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSslAlgorithmInstance i | i.getAvc() = this and result = i)
  }
}
