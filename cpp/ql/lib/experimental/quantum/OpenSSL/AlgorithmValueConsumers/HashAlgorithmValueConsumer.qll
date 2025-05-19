import cpp
private import experimental.quantum.Language
private import semmle.code.cpp.dataflow.new.DataFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstances
private import experimental.quantum.OpenSSL.LibraryDetector

abstract class HashAlgorithmValueConsumer extends OpenSSLAlgorithmValueConsumer { }

/**
 * EVP_Q_Digest directly consumes algorithm constant values
 */
class EVP_Q_Digest_Algorithm_Consumer extends OpenSSLAlgorithmValueConsumer {
  EVP_Q_Digest_Algorithm_Consumer() {
    isPossibleOpenSSLFunction(this.(Call).getTarget()) and
    this.(Call).getTarget().getName() = "EVP_Q_digest"
  }

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
