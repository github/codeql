/**
 * Provides a taint tracking configuration for reasoning about insecure mass assignment.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.dataflow.RemoteFlowSources

/** Provides default sources and sinks for the mass assignment query. */
module MassAssignment {
  /**
   * A data flow source for user input used for mass assignment.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for user input used for mass assignment.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A call that permits arbitrary parameters to be used for mass assignment.
   */
  abstract class MassPermit extends DataFlow::Node {
    /** Gets the argument for the parameters to be permitted */
    abstract DataFlow::Node getParamsArgument();

    /** Gets the result node of the permitted parameters. */
    abstract DataFlow::Node getPermittedParamsResult();
  }

  private class RemoteSource extends Source instanceof RemoteFlowSource { }

  private class CreateSink extends Sink {
    CreateSink() {
      exists(DataFlow::CallNode create |
        create.asExpr().getExpr().(MethodCall).getMethodName() = ["create", "new", "update"] and
        this = create.getArgument(0)
      )
    }
  }

  private class PermitCall extends MassPermit instanceof DataFlow::CallNode {
    PermitCall() { this.asExpr().getExpr().(MethodCall).getMethodName() = "permit!" }

    override DataFlow::Node getParamsArgument() { result = this.(DataFlow::CallNode).getReceiver() }

    override DataFlow::Node getPermittedParamsResult() { result = this }
  }
}

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
    // or
    // node = any(MassAssignment::MassPermit p).getPermittedParamsResult() and
    // state instanceof FlowState::Permitted
  }

  predicate isSink(DataFlow::Node node, FlowState state) {
    node instanceof MassAssignment::Sink and
    state instanceof FlowState::Permitted
  }

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
}

/** Taint tracking for reasoning about user input used for mass assignment. */
module MassAssignmentFlow = TaintTracking::GlobalWithState<Config>;
