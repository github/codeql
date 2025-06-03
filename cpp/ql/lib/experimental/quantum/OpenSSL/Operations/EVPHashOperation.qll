/**
 * https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
 */

private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
private import OpenSSLOperationBase
private import EVPHashInitializer
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

// import EVPHashConsumers
abstract class EVP_Hash_Operation extends OpenSSLOperation, Crypto::HashOperationInstance {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  Expr getAlgorithmArg() { result = this.getInitCall().getAlgorithmArg() }

  EVP_Hash_Initializer getInitCall() {
    CTXFlow::ctxArgFlowsToCtxArg(result.getContextArg(), this.getContextArg())
  }

  /**
   * By default, the algorithm value comes from the init call.
   * There are variants where this isn't true, in which case the
   * subclass should override this method.
   */
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    AlgGetterToAlgConsumerFlow::flow(result.(OpenSSLAlgorithmValueConsumer).getResultNode(),
      DataFlow::exprNode(this.getAlgorithmArg()))
  }
}

private module AlgGetterToAlgConsumerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSSLAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(EVP_Hash_Operation c | c.getAlgorithmArg() = sink.asExpr())
  }
}

private module AlgGetterToAlgConsumerFlow = DataFlow::Global<AlgGetterToAlgConsumerConfig>;

//https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
class EVP_Q_Digest_Operation extends EVP_Hash_Operation {
  EVP_Q_Digest_Operation() { this.(Call).getTarget().getName() = "EVP_Q_digest" }

  //override Crypto::AlgorithmConsumer getAlgorithmConsumer() {  }
  override EVP_Hash_Initializer getInitCall() {
    // This variant of digest does not use an init
    // and even if it were used, the init would be ignored/undefined
    none()
  }

  override Expr getOutputArg() { result = this.(Call).getArgument(5) }

  override Expr getInputArg() { result = this.(Call).getArgument(3) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { result = this.getOutputNode() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() { result = this.getInputNode() }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    // The operation is a direct algorithm consumer
    // NOTE: the operation itself is already modeld as a value consumer, so we can
    // simply return 'this', see modeled hash algorithm consuers for EVP_Q_Digest
    this = result
  }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(1) }
}

class EVP_Digest_Operation extends EVP_Hash_Operation {
  EVP_Digest_Operation() { this.(Call).getTarget().getName() = "EVP_Digest" }

  // There is no context argument for this function
  override Expr getContextArg() { none() }

  override EVP_Hash_Initializer getInitCall() {
    // This variant of digest does not use an init
    // and even if it were used, the init would be ignored/undefined
    none()
  }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(4) }

  override Expr getOutputArg() { result = this.(Call).getArgument(2) }

  override Expr getInputArg() { result = this.(Call).getArgument(0) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { result = this.getOutputNode() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() { result = this.getInputNode() }
}

// NOTE: not modeled as hash operations, these are intermediate calls
class EVP_Digest_Update_Call extends Call {
  EVP_Digest_Update_Call() { this.(Call).getTarget().getName() in ["EVP_DigestUpdate"] }

  Expr getInputArg() { result = this.(Call).getArgument(1) }

  DataFlow::Node getInputNode() { result.asExpr() = this.getInputArg() }

  Expr getContextArg() { result = this.(Call).getArgument(0) }
}

class EVP_Digest_Final_Call extends EVP_Hash_Operation {
  EVP_Digest_Final_Call() {
    this.(Call).getTarget().getName() in [
        "EVP_DigestFinal", "EVP_DigestFinal_ex", "EVP_DigestFinalXOF"
      ]
  }

  EVP_Digest_Update_Call getUpdateCalls() {
    CTXFlow::ctxArgFlowsToCtxArg(result.getContextArg(), this.getContextArg())
  }

  override Expr getInputArg() { result = this.getUpdateCalls().getInputArg() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() { result = this.getInputNode() }

  override Expr getOutputArg() { result = this.(Call).getArgument(1) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { result = this.getOutputNode() }
}
