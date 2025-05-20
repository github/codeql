import cpp
private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.LibraryDetector
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstances

abstract class PKeyValueConsumer extends OpenSSLAlgorithmValueConsumer { }

class EVPPKeyAlgorithmConsumer extends PKeyValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EVPPKeyAlgorithmConsumer() {
    resultNode.asExpr() = this.(Call) and // in all cases the result is the return
    isPossibleOpenSSLFunction(this.(Call).getTarget()) and
    (
      // NOTE: some of these consumers are themselves key gen operations,
      // in these cases, the operation will be created separately for the same function.
      this.(Call).getTarget().getName() in [
          "EVP_PKEY_CTX_new_id", "EVP_PKEY_new_raw_private_key", "EVP_PKEY_new_raw_public_key",
          "EVP_PKEY_new_mac_key"
        ] and
      valueArgNode.asExpr() = this.(Call).getArgument(0)
      or
      this.(Call).getTarget().getName() in [
          "EVP_PKEY_CTX_new_from_name", "EVP_PKEY_new_raw_private_key_ex",
          "EVP_PKEY_new_raw_public_key_ex", "EVP_PKEY_CTX_ctrl", "EVP_PKEY_CTX_set_group_name"
        ] and
      valueArgNode.asExpr() = this.(Call).getArgument(1)
      or
      // argInd 2 is 'type' which can be RSA, or EC
      // if RSA argInd 3 is the key size, else if EC argInd 3 is the curve name
      // In all other cases there is no argInd 3, and argInd 2 is the algorithm.
      // Since this is a key gen operation, handling the key size should be handled
      // when the operation is again modeled as a key gen operation.
      this.(Call).getTarget().getName() = "EVP_PKEY_Q_keygen" and
      (
        // Ellipitic curve case
        // If the argInd 3 is a derived type (pointer or array) then assume it is a curve name
        if this.(Call).getArgument(3).getType().getUnderlyingType() instanceof DerivedType
        then valueArgNode.asExpr() = this.(Call).getArgument(3)
        else
          // All other cases
          valueArgNode.asExpr() = this.(Call).getArgument(2)
      )
    )
  }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSSLAlgorithmInstance i | i.getAVC() = this and result = i)
  }

  override DataFlow::Node getResultNode() { result = resultNode }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result = valueArgNode }
}
