import java
import experimental.quantum.Language
import semmle.code.java.dataflow.DataFlow

/**
 * A signature for the `getInstance()` method calls used in JCA, or direct
 * constructor calls used in BouncyCastle.
 */
signature class NewCallSig instanceof Call;

signature class InitCallSig instanceof MethodCall;

signature class UseCallSig instanceof MethodCall {
  /**
   * Holds if the use is not a final use, such as an `update()` call before `doFinal()`
   */
  predicate isIntermediate();
}

/**
 * A generic analysis module for analyzing data flow from class instantiation,
 * to `init()`, to `doOperation()` in BouncyCastle, and similar patterns in
 * other libraries.
 *
 * For example:
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

  module GetInstanceToInitToUseConfig implements DataFlow::StateConfigSig {
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

  module NewToInitToUseFlow = DataFlow::GlobalWithState<GetInstanceToInitToUseConfig>;

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

predicate additionalFlowSteps(DataFlow::Node node1, DataFlow::Node node2) {
  exists(KeyAdditionalFlowSteps call |
    node1 = call.getInputNode() and
    node2 = call.getOutputNode()
  )
}

class ArtifactAdditionalFlowStep extends AdditionalFlowInputStep {
  DataFlow::Node output;

  ArtifactAdditionalFlowStep() { additionalFlowSteps(this, output) }

  override DataFlow::Node getOutput() { result = output }
}
