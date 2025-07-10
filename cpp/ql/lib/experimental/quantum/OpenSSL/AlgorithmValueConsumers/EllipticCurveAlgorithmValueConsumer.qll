import cpp
private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstances

abstract class EllipticCurveValueConsumer extends OpenSslAlgorithmValueConsumer { }

//https://docs.openssl.org/3.0/man3/EC_KEY_new/#name
class EvpEllipticCurveAlgorithmConsumer extends EllipticCurveValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EvpEllipticCurveAlgorithmConsumer() {
    resultNode.asExpr() = this.(Call) and // in all cases the result is the return
    (
      this.(Call).getTarget().getName() in ["EVP_EC_gen", "EC_KEY_new_by_curve_name"] and
      valueArgNode.asExpr() = this.(Call).getArgument(0)
      or
      this.(Call).getTarget().getName() in [
          "EC_KEY_new_by_curve_name_ex", "EVP_PKEY_CTX_set_ec_paramgen_curve_nid"
        ] and
      valueArgNode.asExpr() = this.(Call).getArgument(2)
    )
  }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSslAlgorithmInstance i | i.getAvc() = this and result = i)
  }

  override DataFlow::Node getResultNode() { result = resultNode }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result = valueArgNode }
}
