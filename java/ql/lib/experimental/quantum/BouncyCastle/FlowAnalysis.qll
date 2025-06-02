import java
import semmle.code.java.dataflow.DataFlow
import experimental.quantum.Language
import AlgorithmInstances
import AlgorithmValueConsumers

/**
 * A signature for the `getInstance()` method calls used in JCA, or direct
 * constructor calls used in BouncyCastle.
 */
signature class NewCallSig instanceof Call {
  /**
   * Gets a parameter argument that is used to initialize the object.
   */
  DataFlow::Node getParametersInput();

  /**
   * Gets a `ECCurve` argument that is used to initialize the object.
   */
  DataFlow::Node getEllipticCurveInput();
}

signature class InitCallSig instanceof MethodCall {
  /**
   * Gets a parameter argument that is used to initialize the object.
   */
  DataFlow::Node getParametersInput();
}

signature class UseCallSig instanceof MethodCall {
  /**
   * Holds if the use is not a final use, such as an `update()` call before `doFinal()`.
   */
  predicate isIntermediate();
}

/**
 * A generic analysis module for analyzing data flow from class instantiation,
 * to `init()`, to `doOperation()` in BouncyCastle, and similar patterns in
 * other libraries.
 *
 * Example:
 * ```
 * gen = new KeyGenerator(...);
 * gen.init(...);
 * gen.generateKeyPair(...);
 * ```
 */
module NewToInitToUseFlowAnalysis<NewCallSig New, InitCallSig Init, UseCallSig Use> {
  newtype TFlowState =
    TUninitialized() or
    TInitialized(Init call) or
    TIntermediateUse(Use call)

  abstract class InitFlowState extends TFlowState {
    string toString() {
      this = TUninitialized() and result = "Uninitialized"
      or
      this = TInitialized(_) and result = "Initialized"
      // TODO: add intermediate use
    }
  }

  // The flow state is uninitialized if the `init` call is not yet made.
  class UninitializedFlowState extends InitFlowState, TUninitialized { }

  class InitializedFlowState extends InitFlowState, TInitialized {
    Init call;
    DataFlow::Node node1;
    DataFlow::Node node2; // The receiver of the `init` call

    InitializedFlowState() {
      this = TInitialized(call) and
      node2.asExpr() = call.(MethodCall).getQualifier() and
      DataFlow::localFlowStep(node1, node2) and
      node1 != node2
    }

    Init getInitCall() { result = call }

    DataFlow::Node getFstNode() { result = node1 }

    DataFlow::Node getSndNode() { result = node2 }
  }

  class IntermediateUseState extends InitFlowState, TIntermediateUse {
    Use call;
    DataFlow::Node node1; // The receiver of the method call
    DataFlow::Node node2;

    IntermediateUseState() {
      this = TIntermediateUse(call) and
      call.isIntermediate() and
      node1.asExpr() = call.(MethodCall).getQualifier() and
      node2 = node1
    }

    Use getUseCall() { result = call }

    DataFlow::Node getFstNode() { result = node1 }

    DataFlow::Node getSndNode() { result = node2 }
  }

  module NewToInitToUseConfig implements DataFlow::StateConfigSig {
    class FlowState = InitFlowState;

    predicate isSource(DataFlow::Node src, FlowState state) {
      state instanceof UninitializedFlowState and
      src.asExpr() instanceof New
      or
      src = state.(InitializedFlowState).getSndNode()
      or
      src = state.(IntermediateUseState).getSndNode()
    }

    // TODO: document this, but this is intentional (avoid cross products?)
    predicate isSink(DataFlow::Node sink, FlowState state) { none() }

    predicate isSink(DataFlow::Node sink) {
      exists(Init c | c.(MethodCall).getQualifier() = sink.asExpr())
      or
      exists(Use c | not c.isIntermediate() and c.(MethodCall).getQualifier() = sink.asExpr())
    }

    predicate isAdditionalFlowStep(
      DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
    ) {
      state1 = state1 and
      (
        node1 = state2.(InitializedFlowState).getFstNode() and
        node2 = state2.(InitializedFlowState).getSndNode()
        or
        node1 = state2.(IntermediateUseState).getFstNode() and
        node2 = state2.(IntermediateUseState).getSndNode()
      )
    }

    predicate isBarrier(DataFlow::Node node, FlowState state) {
      exists(Init call | node.asExpr() = call.(MethodCall).getQualifier() |
        // Ensures that the receiver of a call to `init` is tracked as initialized.
        state instanceof UninitializedFlowState
        or
        // Ensures that call tracked by the state is the last call to `init`.
        state.(InitializedFlowState).getInitCall() != call
      )
    }
  }

  module NewToInitToUseFlow = DataFlow::GlobalWithState<NewToInitToUseConfig>;

  New getNewFromUse(Use use, NewToInitToUseFlow::PathNode src, NewToInitToUseFlow::PathNode sink) {
    src.getNode().asExpr() = result and
    sink.getNode().asExpr() = use.(MethodCall).getQualifier() and
    NewToInitToUseFlow::flowPath(src, sink)
  }

  New getNewFromInit(Init init, NewToInitToUseFlow::PathNode src, NewToInitToUseFlow::PathNode sink) {
    src.getNode().asExpr() = result and
    sink.getNode().asExpr() = init.(MethodCall).getQualifier() and
    NewToInitToUseFlow::flowPath(src, sink)
  }

  Init getInitFromUse(Use use, NewToInitToUseFlow::PathNode src, NewToInitToUseFlow::PathNode sink) {
    src.getNode().asExpr() = result.(MethodCall).getQualifier() and
    sink.getNode().asExpr() = use.(MethodCall).getQualifier() and
    NewToInitToUseFlow::flowPath(src, sink)
  }

  predicate hasInit(Use use) { exists(getInitFromUse(use, _, _)) }

  Use getAnIntermediateUseFromFinalUse(
    Use final, NewToInitToUseFlow::PathNode src, NewToInitToUseFlow::PathNode sink
  ) {
    not final.isIntermediate() and
    result.isIntermediate() and
    src.getNode().asExpr() = result.(MethodCall).getQualifier() and
    sink.getNode().asExpr() = final.(MethodCall).getQualifier() and
    NewToInitToUseFlow::flowPath(src, sink)
  }
}

/**
 * An `ECCurve` instance constructed by a call to either of the methods
 * `X9ECParameters.getCurve()` or `ECNamedCurveParameterSpec.getCurve()`.
 */
private class CurveInstantiation extends MethodCall {
  CurveInstantiation() {
    this.getCallee().getDeclaringType() instanceof Params::Parameters and
    this.getCallee().getName() = "getCurve"
  }

  DataFlow::Node getInputNode() { result.asExpr() = this.getQualifier() }

  DataFlow::Node getOutputNode() { result.asExpr() = this }
}

/**
 * A flow analysis module for analyzing data flow from the instantiation of a
 * parameter object to an `init()` call in BouncyCastle, and similar patterns in
 * other libraries.
 *
 * Example:
 * ```
 * params = new ECKeyGenerationParameters(...);
 * gen = new ECKeyPairGenerator();
 * gen.init(params);
 * ```
 *
 * TODO: Rewrite using stateful data flow to track whether or not the node
 * represents a parameter object or a curve.
 */
module ParametersToInitFlowAnalysis<NewCallSig New, InitCallSig Init> {
  module ParametersToInitConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source.asExpr() instanceof New }

    predicate isSink(DataFlow::Node sink) { exists(Init init | sink = init.getParametersInput()) }

    /**
     * Pass-through for parameters created from other parameters.
     *
     * As an example, below we want to track the flow from the `X9ECParameters`
     * constructor call to the `keyPairGenerator.init()` call to be able to
     * determine the curve associated with the generator.
     *
     * Example:
     * ```
     * X9ECParameters ecParams = SECNamedCurves.getByName("secp256r1");
     * ECDomainParameters domainParams = new ECDomainParameters(ecParams);
     * ECKeyGenerationParameters keyGenParams = new ECKeyGenerationParameters(domainParams, ...);
     * ECKeyPairGenerator keyPairGenerator = new ECKeyPairGenerator();
     * keyPairGenerator.init(keyGenParams);
     * ```
     *
     * We also want to track flow from parameters to the `init()` call
     * via a curve instantiation. E.g. via a call to `getCurve()` as follows:
     *
     * Example:
     * ```
     * X9ECParameters ecParams = SECNamedCurves.getByName("secp256r1");
     * ECCurve curve = ecParams.getCurve();
     * ECDomainParameters domainParams = new ECDomainParameters(curve, ...);
     * ECKeyGenerationParameters keyGenParams = new ECKeyGenerationParameters(domainParams, ...);
     * ECKeyPairGenerator keyPairGenerator = new ECKeyPairGenerator();
     * keyPairGenerator.init(keyGenParams);
     */
    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      // Flow from a parameter node to a new parameter node.
      node1.asExpr().getType() instanceof Params::Parameters and
      node1 = node2.asExpr().(New).getParametersInput()
      or
      // Flow from a curve node to a parameter node.
      node1.asExpr().getType() instanceof Params::Curve and
      node1 = node2.asExpr().(New).getEllipticCurveInput()
      or
      // Flow from a parameter node instance to a curve node.
      exists(CurveInstantiation c |
        node1 = c.getInputNode() and
        node2 = c.getOutputNode()
      )
    }
  }

  module ParametersToInitFlow = DataFlow::Global<ParametersToInitConfig>;

  New getParametersFromInit(
    Init init, ParametersToInitFlow::PathNode src, ParametersToInitFlow::PathNode sink
  ) {
    src.getNode().asExpr() = result and
    sink.getNode() = init.getParametersInput() and
    ParametersToInitFlow::flowPath(src, sink)
  }
}

/**
 * Model data flow from a key pair to the public and private components of the
 * key pair.
 */
class KeyAdditionalFlowSteps extends MethodCall {
  KeyAdditionalFlowSteps() {
    this.getCallee().getDeclaringType().getPackage().getName() = "org.bouncycastle.crypto" and
    this.getCallee().getDeclaringType().getName().matches("%KeyPair") and
    (
      this.getCallee().getName().matches("getPublic")
      or
      this.getCallee().getName().matches("getPrivate")
    )
  }

  DataFlow::Node getInputNode() { result.asExpr() = this.getQualifier() }

  DataFlow::Node getOutputNode() { result.asExpr() = this }
}

/**
 * Model data flow from an ECDSA signature to the scalars r and s passed to
 * `verifySignature()`. The ECDSA signature is represented as a `BigInteger`
 * array, where the first element is the scalar r and the second element is the
 * scalar s.
 */
class ECDSASignatureAdditionalFlowSteps extends ArrayAccess {
  ECDSASignatureAdditionalFlowSteps() {
    this.getArray().getType().getName() = "BigInteger[]" and
    // It is reasonable to assume that the indices are integer literals
    this.getIndexExpr().(IntegerLiteral).getValue().toInt() = [0, 1]
  }

  /**
   * The input node is the ECDSA signature represented as a `BigInteger` array.
   */
  DataFlow::Node getInputNode() {
    // TODO: This should be the array node `this.getArray()`
    result.asExpr() = this.getArray()
  }

  /**
   * The output node is the `BigInteger` element accessed by this array access.
   */
  DataFlow::Node getOutputNode() { result.asExpr() = this }
}

predicate additionalFlowSteps(DataFlow::Node node1, DataFlow::Node node2) {
  exists(KeyAdditionalFlowSteps fs |
    node1 = fs.getInputNode() and
    node2 = fs.getOutputNode()
  )
  or
  exists(ECDSASignatureAdditionalFlowSteps fs |
    node1 = fs.getInputNode() and
    node2 = fs.getOutputNode()
  )
}

class ArtifactAdditionalFlowStep extends AdditionalFlowInputStep {
  DataFlow::Node output;

  ArtifactAdditionalFlowStep() { additionalFlowSteps(this, output) }

  override DataFlow::Node getOutput() { result = output }
}

module EllipticCurveStringLiteralToConsumer {
  /**
   * Flow from a known elliptic curve name to an elliptic curve algorithm consumer.
   */
  module EllipticCurveStringLiteralToAlgorithmValueConsumerConfig implements DataFlow::ConfigSig {
    // NOTE: We do not reference EllipticCurveStringLiteralInstance directly
    // here to avoid non-monotonic recursion.
    predicate isSource(DataFlow::Node src) { src.asExpr() instanceof StringLiteral }

    predicate isSink(DataFlow::Node sink) {
      exists(EllipticCurveAlgorithmValueConsumer consumer | sink = consumer.getInputNode())
    }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      node2.asExpr().(MethodCall).getCallee().getName() = "getCurve" and
      node2.asExpr().(MethodCall).getQualifier() = node1.asExpr()
    }
  }

  module EllipticCurveStringLiteralToAlgorithmValueConsumerFlow =
    DataFlow::Global<EllipticCurveStringLiteralToAlgorithmValueConsumerConfig>;

  EllipticCurveAlgorithmValueConsumer getConsumerFromLiteral(
    StringLiteral literal, EllipticCurveStringLiteralToAlgorithmValueConsumerFlow::PathNode src,
    EllipticCurveStringLiteralToAlgorithmValueConsumerFlow::PathNode sink
  ) {
    src.getNode().asExpr() = literal and
    sink.getNode() = result.getInputNode() and
    EllipticCurveStringLiteralToAlgorithmValueConsumerFlow::flowPath(src, sink)
  }
}
