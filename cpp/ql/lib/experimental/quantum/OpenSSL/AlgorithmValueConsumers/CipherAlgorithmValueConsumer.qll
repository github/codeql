import cpp
private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import OpenSSLAlgorithmValueConsumerBase

abstract class CipherAlgorithmValueConsumer extends OpenSslAlgorithmValueConsumer { }

// https://www.openssl.org/docs/manmaster/man3/EVP_CIPHER_fetch.html
class EvpCipherAlgorithmValueConsumer extends CipherAlgorithmValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EvpCipherAlgorithmValueConsumer() {
    resultNode.asExpr() = this and
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
    exists(OpenSslAlgorithmInstance i | i.getAvc() = this and result = i)
    //TODO: As a potential alternative, for OpenSsl only, add a generic source node for literals and only create flow (flowsTo) to
    // OpenSsl AVCs... the unknown literal sources would have to be any literals not in the known set.
  }
}
