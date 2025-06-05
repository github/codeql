import cpp
private import experimental.quantum.Language
private import semmle.code.cpp.dataflow.new.DataFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstances

abstract class HashAlgorithmValueConsumer extends OpenSSLAlgorithmValueConsumer { }

/**
 * EVP_Q_Digest directly consumes algorithm constant values
 */
class EVP_Q_Digest_Algorithm_Consumer extends HashAlgorithmValueConsumer {
  EVP_Q_Digest_Algorithm_Consumer() { this.(Call).getTarget().getName() = "EVP_Q_digest" }

  override Crypto::ConsumerInputDataFlowNode getInputNode() {
    result.asExpr() = this.(Call).getArgument(1)
  }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSSLAlgorithmInstance i | i.getAVC() = this and result = i)
  }

  override DataFlow::Node getResultNode() {
    // EVP_Q_Digest directly consumes the algorithm constant value and performs the operation, there is no
    // algorithm result
    none()
  }
}

/**
 * The EVP digest algorithm getters
 * https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
 */
class EVPDigestAlgorithmValueConsumer extends HashAlgorithmValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EVPDigestAlgorithmValueConsumer() {
    resultNode.asExpr() = this and
    (
      this.(Call).getTarget().getName() in [
          "EVP_get_digestbyname", "EVP_get_digestbynid", "EVP_get_digestbyobj"
        ] and
      valueArgNode.asExpr() = this.(Call).getArgument(0)
      or
      this.(Call).getTarget().getName() = "EVP_MD_fetch" and
      valueArgNode.asExpr() = this.(Call).getArgument(1)
    )
  }

  override DataFlow::Node getResultNode() { result = resultNode }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result = valueArgNode }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSSLAlgorithmInstance i | i.getAVC() = this and result = i)
  }
}
