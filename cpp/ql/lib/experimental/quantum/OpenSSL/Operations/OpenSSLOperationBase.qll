private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AvcFlow
private import experimental.quantum.OpenSSL.CtxFlow
private import experimental.quantum.OpenSSL.KeyFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
// Importing these intializers here to ensure the are part of any model that is
// using OpenSSLOperationBase. This futher ensures that initializers are tied to opeartions
// even if only importing the operation by itself.
import EVPPKeyCtxInitializer

module EncValToInitEncArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getValue().toInt() in [0, 1] }

  predicate isSink(DataFlow::Node sink) {
    exists(EvpKeyOperationSubtypeInitializer initCall |
      sink.asExpr() = initCall.getKeyOperationSubtypeArg()
    )
  }
}

module EncValToInitEncArgFlow = DataFlow::Global<EncValToInitEncArgConfig>;

private predicate argToAVC(Expr arg, Crypto::AlgorithmValueConsumer avc) {
  // NOTE: because we trace through keys to their sources we must consider that the arg is an avc
  // Consider this example:
  //      EVP_PKEY *pkey = EVP_PKEY_new_mac_key(EVP_PKEY_HMAC, NULL, key, key_len);
  // The key may trace into a signing operation. Tracing through the key we will get the arg taking `EVP_PKEY_HMAC`
  // as the algorithm value consumer (the input node of the AVC). The output node of this AVC
  // is the call return of `EVP_PKEY_new_mac_key`. If we trace from the AVC result to
  // the input argument this will not be possible (from the return to the call argument is a backwards flow).
  // Therefore, we must consider the input node of the AVC as the argument.
  // This should only occur due to tracing through keys to find configuration data.
  avc.getInputNode().asExpr() = arg
  or
  AvcToCallArgFlow::flow(avc.(OpenSSLAlgorithmValueConsumer).getResultNode(),
    DataFlow::exprNode(arg))
}

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
    argToAVC(this.getAlgorithmArg(), result)
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
   * Gets the context argument or return that ties together initialization, updates and/or final calls.
   * The context is the context coming into the initializer and is the output as well.
   * This is assumed to be the same argument.
   */
  abstract CtxPointerSource getContext();
}

abstract class EvpKeySizeInitializer extends EvpInitializer {
  abstract Expr getKeySizeArg();
}

abstract class EvpKeyOperationSubtypeInitializer extends EvpInitializer {
  abstract Expr getKeyOperationSubtypeArg();

  private Crypto::KeyOperationSubtype intToCipherOperationSubtype(int i) {
    i = 0 and
    result instanceof Crypto::TEncryptMode
    or
    i = 1 and result instanceof Crypto::TDecryptMode
  }

  Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    exists(DataFlow::Node a, DataFlow::Node b |
      EncValToInitEncArgFlow::flow(a, b) and
      b.asExpr() = this.getKeyOperationSubtypeArg() and
      result = this.intToCipherOperationSubtype(a.asExpr().getValue().toInt())
    )
    or
    // Infer the subtype from the initialization call, and ignore the argument
    this.(Call).getTarget().getName().toLowerCase().matches("%encrypt%") and
    result instanceof Crypto::TEncryptMode
    or
    this.(Call).getTarget().getName().toLowerCase().matches("%decrypt%") and
    result instanceof Crypto::TDecryptMode
  }
}

/**
 * An primary algorithm initializer initializes the primary algorithm for a given operation.
 * For example, for a signing operation, the algorithm initializer may initialize algorithms
 * like RSA. Other algorithsm may be initialized on an operation, as part of a larger
 * operation/protocol. For example, hashing operations on signing operations; however,
 * these are not the primary algorithm. Any other algorithms initialized on an operation
 * require a specialized initializer, such as EvpHashAlgorithmInitializer.
 */
abstract class EvpPrimaryAlgorithmInitializer extends EvpInitializer {
  abstract Expr getAlgorithmArg();

  Crypto::AlgorithmValueConsumer getAlgorithmValueConsumer() {
    argToAVC(this.getAlgorithmArg(), result)
  }
}

abstract class EvpKeyInitializer extends EvpInitializer {
  abstract Expr getKeyArg();
}

/**
 * Any key initializer may initialize the algorithm and the key size through
 * the key. Extend any instance of key initializer provide initialization
 * of the algorithm and key size from the key.
 */
class EvpInitializerThroughKey extends EvpPrimaryAlgorithmInitializer, EvpKeySizeInitializer instanceof EvpKeyInitializer
{
  //TODO: charpred that traces from creation to key arg, grab creator
  override CtxPointerSource getContext() { result = EvpKeyInitializer.super.getContext() }

  override Expr getAlgorithmArg() {
    result =
      getSourceKeyCreationInstanceFromArg(this.getKeyArg()).(OpenSSLOperation).getAlgorithmArg()
  }

  override Expr getKeySizeArg() {
    result = getSourceKeyCreationInstanceFromArg(this.getKeyArg()).getKeySizeConsumer().asExpr()
  }

  Expr getKeyArg() { result = EvpKeyInitializer.super.getKeyArg() }
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

abstract class EvpHashAlgorithmInitializer extends EvpInitializer {
  abstract Expr getHashAlgorithmArg();

  Crypto::AlgorithmValueConsumer getHashAlgorithmValueConsumer() {
    argToAVC(this.getHashAlgorithmArg(), result)
  }
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
  abstract CtxPointerSource getContext();

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
 * The base class for all operations of the EVP API.
 * This captures one-shot APIs (with and without an initilizer call) and final calls.
 * Provides some default methods for Crypto::KeyOperationInstance class.
 */
abstract class EvpOperation extends OpenSSLOperation {
  /**
   * Gets the context argument that ties together initialization, updates and/or final calls.
   */
  abstract CtxPointerSource getContext();

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
  EvpInitializer getInitCall() { ctxSrcToSrcFlow(result.getContext(), this.getContext()) }

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
  EvpUpdate getUpdateCalls() { ctxSrcToSrcFlow(result.getContext(), this.getContext()) }

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
// Expr getAlgorithmArgFromContext(Expr contextArg) {
//   exists(EVPPKeyAlgorithmConsumer source |
//     result = source.getValueArgExpr() and
//     ctxFlowsToCtxArg(source.getResultNode().asExpr(), ctx)
//   )
//   or
//   result = getAlgorithmFromKey(getKeyFromCtx(ctx))
// }
