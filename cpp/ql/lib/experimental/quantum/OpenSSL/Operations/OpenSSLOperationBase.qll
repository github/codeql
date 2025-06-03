private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

/**
 * A class for all OpenSSL operations.
 */
abstract class OpenSSLOperation extends Crypto::OperationInstance instanceof Call {
  /**
   * Expression that specifies the algorithm for the operation.
   * Will be an argument of the operation in the simplest case.
   */
  abstract Expr getAlgorithmArg();

  /**
   * Algorithm is specified in initialization call or is implicitly established by the key.
   */
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    AlgGetterToAlgConsumerFlow::flow(result.(OpenSSLAlgorithmValueConsumer).getResultNode(),
      DataFlow::exprNode(this.getAlgorithmArg()))
  }
}

/**
 * A Call to initialization functions from the EVP API.
 * These are not operations in the sense of Crypto::OperationInstance,
 * but they are used to initialize the context for the operation.
 */
abstract class EVPInitialize extends Call {
  /**
   * Gets the context argument that ties together initialization, updates and/or final calls.
   */
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  /**
   * Gets the type of key operation, none if not applicable.
   */
  Crypto::KeyOperationSubtype getKeyOperationSubtype() { none() }

  /**
   * Explicitly specified algorithm or none if implicit (e.g., established by the key).
   * None if not applicable.
   */
  Expr getAlgorithmArg() { none() }

  /**
   * Gets the key for the operation, none if not applicable.
   */
  Expr getKeyArg() { none() }

  /**
   * Gets the IV/nonce, none if not applicable.
   */
  Expr getIVArg() { none() }
}

/**
 * A Call to update functions from the EVP API.
 * These are not operations in the sense of Crypto::OperationInstance,
 * but they are used to update the context for the operation.
 */
abstract class EVPUpdate extends Call {
  /**
   * Gets the context argument that ties together initialization, updates and/or final calls.
   */
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  /**
   * Update calls always have some input data like plaintext or message digest.
   */
  abstract Expr getInputArg();

  /**
   * Update calls sometimes have some output data like a plaintext.
   */
  Expr getOutputArg() { none() }
}

/**
 * Flows from algorithm values to operations, specific to OpenSSL
 */
private module AlgGetterToAlgConsumerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSSLAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(EVPOperation c | c.getAlgorithmArg() = sink.asExpr())
  }
}

private module AlgGetterToAlgConsumerFlow = DataFlow::Global<AlgGetterToAlgConsumerConfig>;

/**
 * The base class for all operations of the EVP API.
 * This captures one-shot APIs (with and without an initilizer call) and final calls.
 * Provides some default methods for Crypto::KeyOperationInstance class
 */
abstract class EVPOperation extends OpenSSLOperation {
  /**
   * Gets the context argument that ties together initialization, updates and/or final calls.
   */
  Expr getContextArg() { result = this.(Call).getArgument(0) }

  /**
   * Some input data like plaintext or message digest.
   * Either argument provided direcly in the call or all arguments that were provided in update calls.
   */
  abstract Expr getInputArg();

  /**
   * Some output data like ciphertext or signature.
   */
  abstract Expr getOutputArg();

  /**
   * Overwrite with an explicitly specified algorithm or leave base implementation to find it in the initialization call.
   */
  override Expr getAlgorithmArg() { result = this.getInitCall().getAlgorithmArg() }

  /**
   * Finds the initialization call, may be none.
   */
  EVPInitialize getInitCall() {
    CTXFlow::ctxArgFlowsToCtxArg(result.getContextArg(), this.getContextArg())
  }

  Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result = DataFlow::exprNode(this.getOutputArg())
  }

  /**
   * Input consumer is the input argument of the call.
   */
  Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result = DataFlow::exprNode(this.getInputArg())
  }
}

/**
 * The final calls of the EVP API.
 */
abstract class EVPFinal extends EVPOperation {
  /**
   * All update calls that were executed before this final call.
   */
  EVPUpdate getUpdateCalls() {
    CTXFlow::ctxArgFlowsToCtxArg(result.getContextArg(), this.getContextArg())
  }

  /**
   * Gets the input data provided to all update calls.
   * If more input data was provided in the final call, override the method.
   */
  override Expr getInputArg() { result = this.getUpdateCalls().getInputArg() }

  /**
   * Gets the output data provided to all update calls.
   * If more output data was provided in the final call, override the method.
   */
  override Expr getOutputArg() { result = this.getUpdateCalls().getOutputArg() }
}
