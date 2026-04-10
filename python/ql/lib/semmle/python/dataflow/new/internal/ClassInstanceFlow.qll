/**
 * Provides a reusable data-flow configuration for tracking class instances
 * through global data-flow with full path support.
 *
 * This module is designed for quality queries that check whether instances
 * of certain classes reach operations that require a specific interface
 * (e.g., `__contains__`, `__iter__`, `__hash__`).
 *
 * The configuration uses two flow states:
 * - `TrackingClass`: tracking a reference to the class itself
 * - `TrackingInstance`: tracking an instance of the class
 *
 * At instantiation points (e.g., `cls()`), the state transitions from
 * `TrackingClass` to `TrackingInstance`. Sinks are only matched in the
 * `TrackingInstance` state.
 */

private import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.ApiGraphs

/** A flow state for tracking class references and their instances. */
abstract class ClassInstanceFlowState extends string {
  bindingset[this]
  ClassInstanceFlowState() { any() }
}

/** A state signifying that the tracked value is a reference to the class itself. */
class TrackingClass extends ClassInstanceFlowState {
  TrackingClass() { this = "TrackingClass" }
}

/** A state signifying that the tracked value is an instance of the class. */
class TrackingInstance extends ClassInstanceFlowState {
  TrackingInstance() { this = "TrackingInstance" }
}

/**
 * Signature module for parameterizing `ClassInstanceFlow` per query.
 */
signature module ClassInstanceFlowSig {
  /** Holds if `cls` is a class whose instances should be tracked to sinks. */
  predicate isRelevantClass(Class cls);

  /** Holds if `sink` is a location where reaching instances indicate a violation. */
  predicate isInstanceSink(DataFlow::Node sink);

  /**
   * Holds if an `isinstance` check against `checkedType` should act as a barrier,
   * suppressing alerts when the instance has been verified to have the expected interface.
   */
  predicate isGuardType(DataFlow::Node checkedType);
}

/**
 * Constructs a global data-flow configuration for tracking instances of
 * relevant classes from their definition to violation sinks.
 */
module ClassInstanceFlow<ClassInstanceFlowSig Sig> {
  /**
   * Holds if `guard` is an `isinstance` call checking `node` against a type
   * that should suppress the alert.
   */
  private predicate isinstanceGuard(DataFlow::GuardNode guard, ControlFlowNode node, boolean branch) {
    exists(DataFlow::CallCfgNode isinstance_call |
      isinstance_call = API::builtin("isinstance").getACall() and
      isinstance_call.getArg(0).asCfgNode() = node and
      (
        Sig::isGuardType(isinstance_call.getArg(1))
        or
        // Also handle tuples of types: isinstance(x, (T1, T2))
        Sig::isGuardType(DataFlow::exprNode(isinstance_call.getArg(1).asExpr().(Tuple).getAnElt()))
      ) and
      guard = isinstance_call.asCfgNode() and
      branch = true
    )
  }

  private module Config implements DataFlow::StateConfigSig {
    class FlowState = ClassInstanceFlowState;

    predicate isSource(DataFlow::Node source, FlowState state) {
      exists(ClassExpr ce |
        Sig::isRelevantClass(ce.getInnerScope()) and
        source.asExpr() = ce and
        state instanceof TrackingClass
      )
    }

    predicate isSink(DataFlow::Node sink, FlowState state) {
      Sig::isInstanceSink(sink) and
      state instanceof TrackingInstance
    }

    predicate isBarrier(DataFlow::Node node) {
      node = DataFlow::BarrierGuard<isinstanceGuard/3>::getABarrierNode()
    }

    predicate isAdditionalFlowStep(
      DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
    ) {
      // Instantiation: class reference at the call function position
      // flows to the call result as an instance.
      stateFrom instanceof TrackingClass and
      stateTo instanceof TrackingInstance and
      exists(CallNode call |
        nodeFrom.asCfgNode() = call.getFunction() and
        nodeTo.asCfgNode() = call and
        // Exclude decorator applications, where the result is a proxy
        // rather than a typical instance.
        not call.getNode() = any(FunctionExpr fe).getADecoratorCall()
      )
    }
  }

  module Flow = DataFlow::GlobalWithState<Config>;
}
