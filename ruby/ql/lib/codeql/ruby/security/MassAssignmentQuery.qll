/**
 * Provides a taint tracking configuration for reasoning about insecure mass assignment.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.dataflow.RemoteFlowSources
private import MassAssignmentCustomizations

private module FlowState {
  private newtype TState =
    TUnpermitted() or
    TPermitted()

  /** A flow state used to distinguish whether arbitrary user parameters have been permitted to be used for mass assignment. */
  class State extends TState {
    string toString() {
      this = TUnpermitted() and result = "unpermitted"
      or
      this = TPermitted() and result = "permitted"
    }
  }

  /** A flow state used for user parameters for which arbitrary parameters have not been permitted to use for mass assignment. */
  class Unpermitted extends State, TUnpermitted { }

  /** A flow state used for user parameters for which arbitrary parameters have been permitted to use for mass assignment. */
  class Permitted extends State, TPermitted { }
}

/** A flow configuration for reasoning about insecure mass assignment. */
private module Config implements DataFlow::StateConfigSig {
  class FlowState = FlowState::State;

  predicate isSource(DataFlow::Node node, FlowState state) {
    node instanceof MassAssignment::Source and
    state instanceof FlowState::Unpermitted
  }

  predicate isSink(DataFlow::Node node, FlowState state) {
    node instanceof MassAssignment::Sink and
    state instanceof FlowState::Permitted
  }

  predicate isBarrierIn(DataFlow::Node node, FlowState state) { isSource(node, state) }

  predicate isBarrierOut(DataFlow::Node node, FlowState state) { isSink(node, state) }

  predicate isBarrier(DataFlow::Node node) { node instanceof MassAssignment::Sanitizer }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    exists(MassAssignment::MassPermit permit |
      node1 = permit.getParamsArgument() and
      state1 instanceof FlowState::Unpermitted and
      node2 = permit.getPermittedParamsResult() and
      state2 instanceof FlowState::Permitted
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Taint tracking for reasoning about user input used for mass assignment. */
module MassAssignmentFlow = TaintTracking::GlobalWithState<Config>;
