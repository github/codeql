private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
// Importing these intializers here to ensure the are part of any model that is
// using OpenSSLOperationBase. This futher ensures that initializers are tied to opeartions
// even if only importing the operation by itself.
import EVPPKeyCtxInitializer

/**
 * A class for all OpenSSL operations.
 */
abstract class OpenSSLOperation extends Crypto::OperationInstance instanceof Call {
  /**
   * Gets the argument that specifies the algorithm for the operation.
   * This argument might not be immediately present at the specified operation.
   * For example, it might be set in an initialization call.
   * Modelers of the operation are resonsible for linking the operation to any
   * initialization calls, and providing that argument as a returned value here.
   */
  abstract Expr getAlgorithmArg();

  /**
   * Algorithm is specified in initialization call or is implicitly established by the key.
   */
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    AlgGetterToArgFlow::flow(result.(OpenSSLAlgorithmValueConsumer).getResultNode(),
      DataFlow::exprNode(this.getAlgorithmArg()))
  }
}

/**
 * A Call to an initialization function for an operation.
 * These are not operations in the sense of Crypto::OperationInstance,
 * but they are used to initialize the context for the operation.
 * There may be multiple initialization calls for the same operation.
 * Intended for use with EvPOperation.
 */
abstract class EvpInitializer extends Call {
  /**
   * Gets the context argument that ties together initialization, updates and/or final calls.
   * The context argument is the context coming into the initializer and is the output as well.
   * This is assumed to be the same argument.
   */
  abstract CtxPointerSource getContextArg();
}

abstract class EvpKeySizeInitializer extends EvpInitializer {
  abstract Expr getKeySizeArg();
}

/**
 * Unlike many initializers, this returns the key operation subtype immediately, not the arg.
 * This is a design choice in the overall model, in that the model will not do any tracking
 * for the subtype argument in any automated fashion. Users are currently expected to find the
 * subtype argument manually and associate a type directly.
 */
abstract class EvpKeyOperationSubtypeInitializer extends EvpInitializer {
  abstract Crypto::KeyOperationSubtype getKeyOperationSubtype();
}

abstract class EvpAlgorithmInitializer extends EvpInitializer {
  abstract Expr getAlgorithmArg();
}

abstract class EvpKeyInitializer extends EvpInitializer {
  //, EvpAlgorithmInitializer {
  abstract Expr getKeyArg();
  // /**
  //  * Any key arg can potentially be traced to find the algorithm used to generate the key.
  //  */
  // override Expr getAlgorithmArg(){
  // }
}

abstract class EvpIVInitializer extends EvpInitializer {
  abstract Expr getIVArg();
}

abstract class EvpPaddingInitializer extends EvpInitializer {
  /**
   * Gets the padding mode argument.
   *  e.g., `EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_PADDING)` argument 1 (0-based)
   */
  abstract Expr getPaddingArg();
}

abstract class EvpSaltLengthInitializer extends EvpInitializer {
  /**
   * Gets the salt length argument.
   * e.g., `EVP_PKEY_CTX_set_scrypt_salt_len(ctx, 16)` argument 1 (0-based)
   */
  abstract Expr getSaltLengthArg();
}

/**
 * A Call to an "update" function.
 * These are not operations in the sense of Crypto::OperationInstance,
 * but produce intermediate results for the operation that are later finalized
 * (see EvpFinal).
 * Intended for use with EvPOperation.
 */
abstract class EvpUpdate extends Call {
  /**
   * Gets the context argument that ties together initialization, updates and/or final calls.
   */
  abstract CtxPointerSource getContextArg();

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
module AlgGetterToArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSSLAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  /**
   * Trace to any call accepting the algorithm.
   * NOTE: users must restrict this set to the operations they are interested in.
   */
  predicate isSink(DataFlow::Node sink) { exists(Call c | c.getAnArgument() = sink.asExpr()) }
}

module AlgGetterToArgFlow = DataFlow::Global<AlgGetterToArgConfig>;

/**
 * The base class for all operations of the EVP API.
 * This captures one-shot APIs (with and without an initilizer call) and final calls.
 * Provides some default methods for Crypto::KeyOperationInstance class.
 */
abstract class EvpOperation extends OpenSSLOperation {
  /**
   * Gets the context argument that ties together initialization, updates and/or final calls.
   */
  abstract CtxPointerSource getContextArg();

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
   * Finds the initialization call, may be none.
   */
  EvpInitializer getInitCall() { ctxSrcToSrcFlow(result.getContextArg(), this.getContextArg()) }

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
 * An EVP final call,
 * which is typicall used in an update/final pattern.
 * Final operations are typically identified by "final" in the name,
 * e.g., "EVP_DigestFinal", "EVP_EncryptFinal", etc.
 * however, this is not a strict rule.
 */
abstract class EVPFinal extends EvpOperation {
  /**
   * All update calls that were executed before this final call.
   */
  EvpUpdate getUpdateCalls() { ctxSrcToSrcFlow(result.getContextArg(), this.getContextArg()) }

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
