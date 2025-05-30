import cpp
private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstances
private import experimental.quantum.OpenSSL.Operations.EVPKeyGenOperation
private import experimental.quantum.OpenSSL.Operations.OpenSSLOperationBase
private import experimental.quantum.OpenSSL.CtxFlow

abstract class PKeyValueConsumer extends OpenSSLAlgorithmValueConsumer { }

class EVPPKeyAlgorithmConsumer extends PKeyValueConsumer {
  DataFlow::Node valueArgNode;
  DataFlow::Node resultNode;

  EVPPKeyAlgorithmConsumer() {
    resultNode.asExpr() = this.(Call) and // in all cases the result is the return
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
          "EVP_PKEY_new_raw_public_key_ex", "EVP_PKEY_CTX_ctrl", "EVP_PKEY_CTX_set_group_name",
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
        // Elliptic curve case
        // If the argInd 3 is a derived type (pointer or array) then assume it is a curve name
        if this.(Call).getArgument(3).getType().getUnderlyingType() instanceof DerivedType
        then valueArgNode.asExpr() = this.(Call).getArgument(3)
        else
          // All other cases
          valueArgNode.asExpr() = this.(Call).getArgument(2)
      )
      // TODO: data flow for EVP_PKEY_CTX_dup
    )
  }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    exists(OpenSSLAlgorithmInstance i | i.getAVC() = this and result = i)
  }

  override DataFlow::Node getResultNode() { result = resultNode }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result = valueArgNode }

  // expose the valueArg as an Expr to avoid circular dependency that may arise
  // when trying to get the valueArg with getInputNode.
  Expr getValueArgExpr() { result = valueArgNode.asExpr() }
}

// TODO: not sure where to put these predicates
Expr getAlgorithmFromArgument(Expr arg) { none() }

/**
 * Given context expression (EVP_PKEY_CTX), finds the algorithm.
 */
Expr getAlgorithmFromCtx(CtxPointerExpr ctx) {
  exists(EVPPKeyAlgorithmConsumer source |
    result = source.getValueArgExpr() and
    ctxFlowsToCtxArg(source.getResultNode().asExpr(), ctx)
  )
  or
  result = getAlgorithmFromKey(getKeyFromCtx(ctx))
}

/**
 * Given context expression (EVP_PKEY_CTX), finds the key used to initialize the context.
 */
Expr getKeyFromCtx(CtxPointerExpr ctx) {
  exists(Call contextCreationCall |
    ctxFlowsToCtxArg(contextCreationCall, ctx) and
    (
      contextCreationCall.getTarget().getName() = "EVP_PKEY_CTX_new" and
      result = contextCreationCall.getArgument(0)
      or
      contextCreationCall.getTarget().getName() = "EVP_PKEY_CTX_new_from_pkey" and
      result = contextCreationCall.getArgument(1)
    )
  )
}

/**
 * Flow from key creation to key used in a call
 */
module OpenSSLKeyFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(EVPKeyGenOperation keygen | keygen.getOutputKeyArtifact() = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(OpenSSLCall call | call.(Call).getAnArgument() = sink.asExpr())
  }
}

module OpenSSLKeyFlow = TaintTracking::Global<OpenSSLKeyFlowConfig>;

/**
 * Given key expression (EVP_PKEY), finds the algorithm.
 */
Expr getAlgorithmFromKey(Expr key) {
  exists(EVPKeyGenOperation keygen |
    OpenSSLKeyFlow::flow(keygen.getOutputKeyArtifact(), DataFlow::exprNode(key)) and
    result = keygen.getAlgorithmArg()
  )
}
