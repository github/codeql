import cpp
private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import OpenSSLAlgorithmValueConsumerBase

abstract class PaddingAlgorithmValueConsumer extends OpenSslAlgorithmValueConsumer { }

// https://docs.openssl.org/master/man7/EVP_ASYM_CIPHER-RSA/#rsa-asymmetric-cipher-parameters
// TODO: need to handle setting padding through EVP_PKEY_CTX_set_params, where modes like "OSSL_PKEY_RSA_PAD_MODE_OAEP"
// are set.
class Evp_PKey_Ctx_set_rsa_padding_AlgorithmValueConsumer extends PaddingAlgorithmValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  Evp_PKey_Ctx_set_rsa_padding_AlgorithmValueConsumer() {
    resultNode.asExpr() = this and
    this.(Call).getTarget().getName() = "EVP_PKEY_CTX_set_rsa_padding" and
    valueArgNode.asExpr() = this.(Call).getArgument(1)
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
