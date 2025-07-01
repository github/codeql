private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
import semmle.code.cpp.dataflow.new.DataFlow
// Importing these intializers here to ensure the are part of any model that is
// using OpenSslOperationBase. This further ensures that initializers are tied to opeartions
// even if only importing the operation by itself.
import EVPPKeyCtxInitializer

/**
 * An openSSL CTX type, which is type for which the stripped underlying type
 * matches the pattern 'evp_%ctx_%st'.
 * This includes types like:
 * - EVP_CIPHER_CTX
 * - EVP_MD_CTX
 * - EVP_PKEY_CTX
 */
class CtxType extends Type {
  CtxType() {
    // It is possible for users to use the underlying type of the CTX variables
    // these have a name matching 'evp_%ctx_%st
    this.getUnspecifiedType().stripType().getName().matches("evp_%ctx_%st")
    or
    // In principal the above check should be sufficient, but in case of build mode none issues
    // i.e., if a typedef cannot be resolved,
    // or issues with properly stubbing test cases, we also explicitly check for the wrapping type defs
    // i.e., patterns matching 'EVP_%_CTX'
    exists(Type base | base = this or base = this.(DerivedType).getBaseType() |
      base.getName().matches("EVP_%_CTX")
    )
  }
}

/**
 * A pointer to a CtxType
 */
class CtxPointerExpr extends Expr {
  CtxPointerExpr() {
    this.getType() instanceof CtxType and
    this.getType() instanceof PointerType
  }
}

/**
 * A call argument of type CtxPointerExpr.
 */
class CtxPointerArgument extends CtxPointerExpr {
  CtxPointerArgument() { exists(Call c | c.getAnArgument() = this) }

  Call getCall() { result.getAnArgument() = this }
}

/**
 * The type of inputs and ouputs for an `OperationStep`.
 */
newtype TIOType =
  CiphertextIO() or
  // Used for typical CTX types, but not for OSSL_PARAM or OSSL_LIB_CTX
  // For OSSL_PARAM and OSSL_LIB_CTX use of OsslParamIO and OsslLibContextIO
  ContextIO() or
  DigestIO() or
  // For OAEP and MGF1 hashes, there is a special IO type for these hashes
  // it is recommended to set the most explicit type known, not both
  HashAlgorithmIO() or
  HashAlgorithmOaepIO() or
  HashAlgorithmMgf1IO() or
  IVorNonceIO() or
  KeyIO() or
  KeyOperationSubtypeIO() or
  KeySizeIO() or
  // Used for OSSL_LIB_CTX
  OsslLibContextIO() or
  // Used for OSSL_PARAM
  OsslParamIO() or
  MacIO() or
  PaddingAlgorithmIO() or
  // Plaintext also includes a message for digest, signature, verification, and mac generation
  PlaintextIO() or
  PrimaryAlgorithmIO() or
  RandomSourceIO() or
  SaltLengthIO() or
  SeedIO() or
  SignatureIO()

private string ioTypeToString(TIOType t) {
  t = CiphertextIO() and result = "CiphertextIO"
  or
  t = ContextIO() and result = "ContextIO"
  or
  t = DigestIO() and result = "DigestIO"
  or
  t = HashAlgorithmIO() and result = "HashAlgorithmIO"
  or
  t = IVorNonceIO() and result = "IVorNonceIO"
  or
  t = KeyIO() and result = "KeyIO"
  or
  t = KeyOperationSubtypeIO() and result = "KeyOperationSubtypeIO"
  or
  t = KeySizeIO() and result = "KeySizeIO"
  or
  t = OsslLibContextIO() and result = "OsslLibContextIO"
  or
  t = OsslParamIO() and result = "OsslParamIO"
  or
  t = MacIO() and result = "MacIO"
  or
  t = PaddingAlgorithmIO() and result = "PaddingAlgorithmIO"
  or
  t = PlaintextIO() and result = "PlaintextIO"
  or
  t = PrimaryAlgorithmIO() and result = "PrimaryAlgorithmIO"
  or
  t = RandomSourceIO() and result = "RandomSourceIO"
  or
  t = SaltLengthIO() and result = "SaltLengthIO"
  or
  t = SeedIO() and result = "SeedIO"
  or
  t = SignatureIO() and result = "SignatureIO"
}

class IOType extends TIOType {
  string toString() {
    result = ioTypeToString(this)
    or
    not exists(ioTypeToString(this)) and result = "UnknownIOType"
  }
}

/**
 * The type of step in an `OperationStep`.
 * - `ContextCreationStep`: the creation of a context from an algorithm or key.
 *                       for example `EVP_MD_CTX_create(EVP_sha256())` or `EVP_PKEY_CTX_new(pkey, NULL)`
 * - `InitializerStep`: the initialization of an operation through some sort of shared/accumulated context
 *                       for example `EVP_DigestInit_ex(ctx, EVP_sha256(), NULL)`
 * - `UpdateStep`: any operation that has and update/final paradigm, the update represents an intermediate step in an operation,
 *                       such as `EVP_DigestUpdate(ctx, data, len)`
 * - `FinalStep`: an ultimate operation step. This may be an explicit 'final' in an update/final paradigm, but not necessarily.
 *                Any operation that does nto operate through an update/final paradigm is considered a final step.
 */
newtype OperationStepType =
  // Context creation captures cases where a context is created from an algorithm or key
  //
  ContextCreationStep() or
  InitializerStep() or
  UpdateStep() or
  FinalStep()

/**
 * A step in configuring an operation.
 * Captures creation of contexts from algorithms or keys,
 * initalization of configurations on contexts,
 * update operations (intermediate steps in an operation)
 * and the operation itself.
 *
 * NOTE: if an operation is configured through a means other than a call
 * e.g., a pattern like ctx->alg = EVP_sha256()
 * then this class will need to be modified to account for that paradigm.
 * Currently, this is not a known pattern in OpenSSL.
 */
abstract class OperationStep extends Call {
  /**
   * Gets the output nodes from the given operation step.
   * These are the nodes that flow connecting this step
   * to any other step in the operation should follow.
   */
  abstract DataFlow::Node getOutput(IOType type);

  /**
   * Gets any output node from the given operation step.
   */
  final DataFlow::Node getAnOutput() { result = this.getOutput(_) }

  /**
   * Gets the input nodes for the given operation step.
   */
  abstract DataFlow::Node getInput(IOType type);

  /**
   * Gets any input node for the given operation step.
   */
  final DataFlow::Node getAnInput() { result = this.getInput(_) }

  /**
   * Gets the type of the step, e.g., ContextCreationStep, InitializerStep, UpdateStep, FinalStep.
   */
  abstract OperationStepType getStepType();

  /**
   * Holds if this operation step flows to the given `OperationStep` `sink`.
   * If `sink` is `this`, then this holds true.
   */
  predicate flowsToOperationStep(OperationStep sink) {
    sink = this or
    OperationStepFlow::flow(this.getAnOutput(), sink.getAnInput())
  }

  /**
   * Holds if this operation step flows from the given `OperationStep` (`source`).
   * If `source` is `this`, then this holds true.
   */
  predicate flowsFromOperationStep(OperationStep source) {
    source = this or
    OperationStepFlow::flow(source.getAnOutput(), this.getAnInput())
  }

  /**
   * Holds if this operation step sets a value of the given `IOType`.
   */
  predicate setsValue(IOType type) { exists(this.getInput(type)) }

  /**
   * Gets operation steps that flow to `this` and set the given `IOType`.
   * This checks for the last initializers that flow to the `this`,
   * i.e., if a value is set then re-set, the last set operation step is returned,
   * not both.
   * Note: Any 'update' that sets a value is not considered to be 'resetting' an input.
   * I.e., there is a difference between changing a configuration before use and
   * the operation allows for multiple inputs (like plaintext for cipher update calls before final).
   */
  OperationStep getDominatingInitializersToStep(IOType type) {
    result.flowsToOperationStep(this) and
    result.setsValue(type) and
    (
      // Do not consider a 'reset' to occur on updates
      result.getStepType() = UpdateStep()
      or
      not exists(OperationStep reset |
        result != reset and
        reset.setsValue(type) and
        reset.flowsToOperationStep(this) and
        result.flowsToOperationStep(reset)
      )
    )
  }

  /**
   * Gets all output of `type` that flow to `this`
   * if `this` is a final step and the output is not from
   * a separate final step.
   */
  OperationStep getOutputStepFlowingToStep(IOType type) {
    this.getStepType() = FinalStep() and
    result.flowsToOperationStep(this) and
    exists(result.getOutput(type)) and
    (result = this or result.getStepType() != FinalStep())
  }

  /**
   * Gets an AVC for the primary algorithm for this operation.
   * A primary algorithm is an AVC that either:
   * 1) flows to a ctx input directly or
   * 2) flows to a primary algorithm input directly
   * 3) flows to a key input directly (algorithm held in a key will be considered primary)
   * See `AvcContextCreationStep` for details about resetting scenarios.
   * Gets the first OperationStep an AVC flows to. If a context input,
   * the AVC is considered primary.
   * If a primary algorithm input, then get the last set primary algorithm
   * operation step (dominating operation step, see `getDominatingInitializersToStep`).
   */
  Crypto::AlgorithmValueConsumer getPrimaryAlgorithmValueConsumer() {
    exists(DataFlow::Node src, DataFlow::Node sink, IOType t, OperationStep avcConsumingPred |
      (t = PrimaryAlgorithmIO() or t = ContextIO() or t = KeyIO()) and
      avcConsumingPred.flowsToOperationStep(this) and
      src.asExpr() = result and
      sink = avcConsumingPred.getInput(t) and
      AvcToOperationStepFlow::flow(src, sink) and
      (
        // Case 1: the avcConsumingPred step is a dominating primary algorithm initialization step
        // or dominating key initialization step
        (t = PrimaryAlgorithmIO() or t = KeyIO()) and
        avcConsumingPred = this.getDominatingInitializersToStep(t)
        or
        // Case 2: the pred is a context input
        t = ContextIO()
      )
    )
  }

  /**
   * Gets the algorithm value consumer for an input to `this` operation step
   * of the given `type`.
   * TODO: generalize to use this for `getPrimaryAlgorithmValueConsumer`
   */
  Crypto::AlgorithmValueConsumer getAlgorithmValueConsumerForInput(IOType type) {
    result = this and this.setsValue(type)
    or
    exists(DataFlow::Node src, DataFlow::Node sink |
      AvcToOperationStepFlow::flow(src, sink) and
      src.asExpr() = result and
      sink = this.getInput(type)
    )
  }
}

/**
 * An AVC is considered to output a 'context type', however,
 * each AVC has it's own output types in practice.
 * Some output algorithm containers (`EVP_get_cipherbyname`)
 * some output explicit contexts (`EVP_PKEY_CTX_new_from_name`).
 * The output of an AVC cannot be determined to be a primary algorithm (PrimaryAlgorithmIO), that depends
 * on the use of the AVC output.
 * The use is assumed to be of two forms:
 * - The AVC output flows to a known input that accepts an algorithm
 *    e.g., `EVP_DigestInit(ctx, type)` the `type` parameter is known to be the primary algorithm.
 *          `EVP_SignInit(ctx, type)` the `type` parameter is known to be a digest algorithm for the signature.
 * - The AVC output flows to a context initialization step
 *    e.g., `pkey_ctx = EVP_PKEY_CTX_new_from_name(libctx, name, propquery)` this is an AVC call, but the
 *    API says the output is a context. It is consumed typically by something like:
 *    `ctx = EVP_PKEY_keygen_init(pkey_ctx)`, but note I cannot consider the `pkey_ctx` parameter to always be a primary algorithm,
 *     a key gen can be inited by a prior key as well, e.g., `ctx = EVP_PKEY_CTX_new(pkey, NULL)`.
 *     Hence, these initialization steps take in a context that may have come from an AVC or something else,
 *     and therefore cannot be considered a primary algorithm.
 * Assumption: The first operation step an AVC flows to will be of the above two forms.
 * Resetting Algorithm Concerns and Assumptions:
 *     What if a user resets the algorithm through another AVC call?
 *     How would we detect that and only look at the 'dominating' (last set) AVC?
 *     From an AVC, always assess the first operation step it flows to.
 *     If the first step is to a context input, then we assume that reset is not possible in the same path.
 *     I.e., a user cannot reset the algorithm without starting an entirely new operation step chain.
 *     See the use patterns for `pkey_ctx = EVP_PKEY_CTX_new_from_name(...)` mentioned above. A user cannot
 *     reset the algorithm without calling a new `ctx = EVP_PKEY_keygen_init(pkey_ctx)`,
 *     i.e., subsequent flow follows the `ctx` output.
 *     If the first step is to any other input, then we use the `getDominatingInitializersToStep`
 *     to find the last AVC that set the algorithm for the operation step.
 *     Domination checks must occur at an operation step (e.g., at a final operation).
 *     This operation step does not find the dominating AVC.
 *     If a primary algorithm is explicitly set and and AVC is set through a context input,
 *     we will use both cases as primary inputs.
 */
class AvcContextCreationStep extends OperationStep instanceof OpenSslAlgorithmValueConsumer {
  override DataFlow::Node getOutput(IOType type) {
    type = ContextIO() and result = super.getResultNode()
  }

  override DataFlow::Node getInput(IOType type) { none() }

  override OperationStepType getStepType() { result = ContextCreationStep() }
}

abstract private class CtxPassThroughCall extends Call {
  abstract DataFlow::Node getNode1();

  abstract DataFlow::Node getNode2();
}

/**
 * A call whose target contains 'free' or 'reset' and has an argument of type
 * CtxPointerArgument.
 */
private class CtxClearCall extends Call {
  CtxClearCall() {
    this.getTarget().getName().toLowerCase().matches(["%free%", "%reset%"]) and
    this.getAnArgument() instanceof CtxPointerArgument
  }
}

/**
 * A call whose target contains 'copy' and has an argument of type
 * CtxPointerArgument.
 */
private class CtxCopyOutArgCall extends CtxPassThroughCall {
  DataFlow::Node n1;
  DataFlow::Node n2;

  CtxCopyOutArgCall() {
    this.getTarget().getName().toLowerCase().matches("%copy%") and
    n1.asExpr() = this.getAnArgument() and
    n1.getType() instanceof CtxType and
    n2.asDefiningArgument() = this.getAnArgument() and
    n2.getType() instanceof CtxType and
    n1.asDefiningArgument() != n2.asExpr()
  }

  override DataFlow::Node getNode1() { result = n1 }

  override DataFlow::Node getNode2() { result = n2 }
}

/**
 * A call whose target contains 'dup' and has an argument of type
 * CtxPointerArgument.
 */
private class CtxCopyReturnCall extends CtxPassThroughCall, CtxPointerExpr {
  DataFlow::Node n1;

  CtxCopyReturnCall() {
    this.getTarget().getName().toLowerCase().matches("%dup%") and
    n1.asExpr() = this.getAnArgument() and
    n1.getType() instanceof CtxType
  }

  override DataFlow::Node getNode1() { result = n1 }

  override DataFlow::Node getNode2() { result.asExpr() = this }
}

// TODO: is this still needed? It appears to be (tests fail without it) but
// I don't know why as EVP_PKEY_paramgen is an operation step and we pass through
// operation steps already.
/**
 * A call to `EVP_PKEY_paramgen` acts as a kind of pass through.
 * It's output pkey is eventually used in a new operation generating
 * a fresh context pointer (e.g., `EVP_PKEY_CTX_new`).
 * It is easier to model this as a pass through
 * than to model the flow from the paramgen to the new key generation.
 */
private class CtxParamGenCall extends CtxPassThroughCall {
  DataFlow::Node n1;
  DataFlow::Node n2;

  CtxParamGenCall() {
    this.getTarget().getName() = "EVP_PKEY_paramgen" and
    n1.asExpr() = this.getArgument(0) and
    (
      n2.asExpr() = this.getArgument(1)
      or
      n2.asDefiningArgument() = this.getArgument(1)
    )
  }

  override DataFlow::Node getNode1() { result = n1 }

  override DataFlow::Node getNode2() { result = n2 }
}

/**
 * A flow configuration from any non-final `OperationStep` to any other `OperationStep`.
 */
module OperationStepFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OperationStep s |
      s.getAnOutput() = source or
      s.getAnInput() = source
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(OperationStep s |
      s.getAnInput() = sink or
      s.getAnOutput() = sink
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(CtxClearCall c | c.getAnArgument() = node.asExpr())
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(CtxPassThroughCall c | c.getNode1() = node1 and c.getNode2() = node2)
    or
    // Flow out through all outputs from an operation step if more than one output
    // is defined.
    exists(OperationStep s | s.getAnInput() = node1 and s.getAnOutput() = node2)
    // TODO: consideration for additional alises defined as follows:
    // if an output from an operation step itself flows from the output of another operation step
    // then the source of that flow's outputs (all of them) are potential aliases
  }
}

module OperationStepFlow = DataFlow::Global<OperationStepFlowConfig>;

/**
 * A flow from AVC to the first `OperationStep` the AVC reaches as an input.
 */
module AvcToOperationStepFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(AvcContextCreationStep s | s.getAnOutput() = source)
  }

  predicate isSink(DataFlow::Node sink) { exists(OperationStep s | s.getAnInput() = sink) }

  predicate isBarrier(DataFlow::Node node) {
    exists(CtxClearCall c | c.getAnArgument() = node.asExpr())
  }

  /**
   * Only get the first operation step encountered.
   */
  predicate isBarrierOut(DataFlow::Node node) { isSink(node) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(CtxPassThroughCall c | c.getNode1() = node1 and c.getNode2() = node2)
  }
}

module AvcToOperationStepFlow = DataFlow::Global<AvcToOperationStepFlowConfig>;

module EncValToInitEncArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getValue().toInt() in [0, 1] }

  predicate isSink(DataFlow::Node sink) {
    exists(OperationStep s | sink = s.getInput(KeyOperationSubtypeIO()))
  }
}

module EncValToInitEncArgFlow = DataFlow::Global<EncValToInitEncArgConfig>;

private Crypto::KeyOperationSubtype intToCipherOperationSubtype(int i) {
  i = 0 and
  result instanceof Crypto::TEncryptMode
  or
  i = 1 and result instanceof Crypto::TDecryptMode
}

Crypto::KeyOperationSubtype resolveKeyOperationSubTypeOperationStep(OperationStep s) {
  exists(DataFlow::Node src |
    EncValToInitEncArgFlow::flow(src, s.getInput(KeyOperationSubtypeIO())) and
    result = intToCipherOperationSubtype(src.asExpr().getValue().toInt())
  )
}
