import cpp
private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.LibraryDetector

abstract class SignatureAlgorithmValueConsumer extends OpenSSLAlgorithmValueConsumer { }

class EVPSignatureAlgorithmValueConsumer extends OpenSSLAlgorithmValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EVPSignatureAlgorithmValueConsumer() {
    resultNode.asExpr() = this and
    isPossibleOpenSSLFunction(this.(Call).getTarget()) and
    (
      // EVP_SIGNATURE
      this.(Call).getTarget().getName() = "EVP_SIGNATURE_fetch" and
      valueArgNode.asExpr() = this.(Call).getArgument(1)
      // EVP_PKEY_get1_DSA, DSA_SIG_new, EVP_RSA_gen
    )
  }

  override DataFlow::Node getResultNode() { result = resultNode }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result = valueArgNode }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSSLAlgorithmInstance i | i.getAVC() = this and result = i)
  }
}
