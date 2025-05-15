import java
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
 * An generic analysis module for analyzing the `getInstance()` to `initialize()` 
 * to `doOperation()` pattern in the JCA, and similar patterns in other libraries.
 *
 * For example:
 * ```
 * kpg = KeyPairGenerator.getInstance();
 * kpg.initialize(...);
 * kpg.generate(...);
 * ```
 */
module NewToInitToUseFlowAnalysis<NewCallSig GetInstance, InitCallSig Init, UseCallSig Use>
{
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

  class UninitializedFlowState extends InitFlowState, TUninitialized { }

  class InitializedFlowState extends InitFlowState, TInitialized {
    Init call;
    DataFlow::Node node1;
    DataFlow::Node node2;

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
    DataFlow::Node node1;
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
      src.asExpr() instanceof GetInstance
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
        state instanceof UninitializedFlowState
        or
        state.(InitializedFlowState).getInitCall() != call
      )
    }
  }

  module GetInstanceToInitToUseFlow = DataFlow::GlobalWithState<GetInstanceToInitToUseConfig>;

  GetInstance getInstantiationFromUse(
    Use use, GetInstanceToInitToUseFlow::PathNode src, GetInstanceToInitToUseFlow::PathNode sink
  ) {
    src.getNode().asExpr() = result and
    sink.getNode().asExpr() = use.(MethodCall).getQualifier() and
    GetInstanceToInitToUseFlow::flowPath(src, sink)
  }

  GetInstance getInstantiationFromInit(
    Init init, GetInstanceToInitToUseFlow::PathNode src, GetInstanceToInitToUseFlow::PathNode sink
  ) {
    src.getNode().asExpr() = result and
    sink.getNode().asExpr() = init.(MethodCall).getQualifier() and
    GetInstanceToInitToUseFlow::flowPath(src, sink)
  }

  Init getInitFromUse(
    Use use, GetInstanceToInitToUseFlow::PathNode src, GetInstanceToInitToUseFlow::PathNode sink
  ) {
    src.getNode().asExpr() = result.(MethodCall).getQualifier() and
    sink.getNode().asExpr() = use.(MethodCall).getQualifier() and
    GetInstanceToInitToUseFlow::flowPath(src, sink)
  }

  predicate hasInit(Use use) { exists(getInitFromUse(use, _, _)) }

  Use getAnIntermediateUseFromFinalUse(
    Use final, GetInstanceToInitToUseFlow::PathNode src, GetInstanceToInitToUseFlow::PathNode sink
  ) {
    not final.isIntermediate() and
    result.isIntermediate() and
    src.getNode().asExpr() = result.(MethodCall).getQualifier() and
    sink.getNode().asExpr() = final.(MethodCall).getQualifier() and
    GetInstanceToInitToUseFlow::flowPath(src, sink)
  }
}