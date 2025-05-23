private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers


abstract class EVPInitialize extends Call {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    none()
  }

  /**
   * Explicitly specified algorithm or none if implicit (e.g., established by the key).
   */
  Expr getAlgorithmArg() { none() }

  Expr getKeyArg() { none() }

  Expr getIVArg() { none() }
}

abstract class EVPUpdate extends Call {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  /**
   * Update has some input data like plaintext or message digest.
   */
  abstract Expr getInputArg();
}

/**
 * Flows from algorithm values to operations, specific to OpenSSL
 */
private module AlgGetterToAlgConsumerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSSLAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(EVPOperation c | c.getInitCall().getAlgorithmArg() = sink.asExpr())
  }
}

private module AlgGetterToAlgConsumerFlow = DataFlow::Global<AlgGetterToAlgConsumerConfig>;


abstract class EVPOperation extends Crypto::OperationInstance {
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  /**
   * Some input data like plaintext or message digest.
   * Either argument provided direcly in the call or all arguments that were provided in update calls.
   */
  abstract Expr getInputArg();

  /**
   * Some output data like ciphertext or signature.
   * Always produced directly by this operation.
   * Assumption: output is provided as an argument to the call, never as return value.
   */
  abstract Expr getOutputArg();

  /**
   * Explicitly specified algorithm or leave base implementation to find it in an init call.
   */
  Expr getAlgorithmArg() {
    if exists(this.getInitCall()) then result = this.getInitCall().getAlgorithmArg()
    else none()
  }

  /**
   * Finds the initialization call, may be none.
   */
  EVPInitialize getInitCall() {
    CTXFlow::ctxArgFlowsToCtxArg(result.getContextArg(), this.getContextArg())
  }

  /**
   * Algorithm was specified in either init call or is implicitly established by the key.
   */
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    AlgGetterToAlgConsumerFlow::flow(result.(OpenSSLAlgorithmValueConsumer).getResultNode(),
      DataFlow::exprNode(this.getAlgorithmArg()))
  }

  Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result.asExpr() = this.getOutputArg()
    // if exists(Call c | c.getAnArgument() = this)
    // then result.asDefiningArgument() = this
    // else result.asExpr() = this
  }

  Crypto::ConsumerInputDataFlowNode getInputConsumer() { result.asExpr() = this.getInputArg() }
}

abstract class EVPFinal extends EVPOperation {
  EVPUpdate getUpdateCalls() {
    CTXFlow::ctxArgFlowsToCtxArg(result.getContextArg(), this.getContextArg())
  }

  override Expr getInputArg() { result = this.getUpdateCalls().getInputArg() }
}

abstract class EVPOneShot extends EVPOperation {
  
}