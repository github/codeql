import cpp
import experimental.Quantum.Language
import experimental.Quantum.OpenSSL.LibraryDetector
import experimental.Quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
import experimental.Quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
import OpenSSLAlgorithmValueConsumerBase

abstract class CipherAlgorithmValueConsumer extends OpenSSLAlgorithmValueConsumer { }

// https://www.openssl.org/docs/manmaster/man3/EVP_CIPHER_fetch.html
class EVPCipherAlgorithmValueConsumer extends CipherAlgorithmValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EVPCipherAlgorithmValueConsumer() {
    resultNode.asExpr() = this and
    isPossibleOpenSSLFunction(this.(Call).getTarget()) and
    (
      this.(Call).getTarget().getName() in [
          "EVP_get_cipherbyname", "EVP_get_cipherbyobj", "EVP_get_cipherbynid"
        ] and
      valueArgNode.asExpr() = this.(Call).getArgument(0)
      or
      this.(Call).getTarget().getName() in ["EVP_CIPHER_fetch", "EVP_ASYM_CIPHER_fetch"] and
      valueArgNode.asExpr() = this.(Call).getArgument(1)
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
