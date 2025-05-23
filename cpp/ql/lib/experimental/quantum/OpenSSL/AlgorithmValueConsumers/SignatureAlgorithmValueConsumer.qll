import cpp
private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import OpenSSLAlgorithmValueConsumerBase

abstract class SignatureAlgorithmValueConsumer extends OpenSSLAlgorithmValueConsumer { }

class EVPSignatureAlgorithmValueConsumer extends OpenSSLAlgorithmValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;
  Function consumer;

  EVPSignatureAlgorithmValueConsumer() {
    resultNode.asExpr() = this and
    this.(Call).getTarget() = consumer and
    (
      // EVP_SIGNATURE
      consumer.getName() = "EVP_SIGNATURE_fetch" and
      valueArgNode.asExpr() = this.(Call).getArgument(1)
      or
      consumer.getName() = "EVP_SIGNATURE_is_a" and
      valueArgNode.asExpr() = this.(Call).getArgument(1)
      // EVP_PKEY_get1_DSA, DSA_SIG_new, EVP_RSA_gen
    )
  }

  override DataFlow::Node getResultNode() { result = resultNode }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result = valueArgNode }

  // override DataFlow::Node getInputNode() { result = valueArgNode }
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSSLAlgorithmInstance i | i.getAVC() = this and result = i)
    //TODO: As a potential alternative, for OpenSSL only, add a generic source node for literals and only create flow (flowsTo) to
    // OpenSSL AVCs... the unknown literal sources would have to be any literals not in the known set.
  }
}
