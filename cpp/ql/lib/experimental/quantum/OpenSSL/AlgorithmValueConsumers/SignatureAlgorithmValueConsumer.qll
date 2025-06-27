import cpp
private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.LibraryDetector

abstract class SignatureAlgorithmValueConsumer extends OpenSslAlgorithmValueConsumer { }

class EvpSignatureAlgorithmValueConsumer extends SignatureAlgorithmValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EvpSignatureAlgorithmValueConsumer() {
    resultNode.asExpr() = this and
    (
      // EVP_SIGNATURE
      this.(Call).getTarget().getName() = "EVP_SIGNATURE_fetch" and
      valueArgNode.asExpr() = this.(Call).getArgument(1)
      // EVP_PKEY_get1_DSA, EVP_PKEY_get1_RSA
      // DSA_SIG_new, DSA_SIG_get0, RSA_sign ?
    )
  }

  override DataFlow::Node getResultNode() { result = resultNode }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result = valueArgNode }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSslAlgorithmInstance i | i.getAvc() = this and result = i)
  }
}
