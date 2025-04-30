/**
 * Provides a taint-tracking configuration for reasoning about
 * unvalidated dynamic method calls.
 *
 * Note, for performance reasons: only import this file if
 * `UnvalidatedDynamicMethodCall::Configuration` is needed, otherwise
 * `UnvalidatedDynamicMethodCallCustomizations` should be imported
 * instead.
 */

import javascript
import semmle.javascript.frameworks.Express
import PropertyInjectionShared
private import semmle.javascript.dataflow.InferredTypes
import UnvalidatedDynamicMethodCallCustomizations::UnvalidatedDynamicMethodCall
private import UnvalidatedDynamicMethodCallCustomizations::UnvalidatedDynamicMethodCall as UnvalidatedDynamicMethodCall

// Materialize flow labels
deprecated private class ConcreteMaybeNonFunction extends MaybeNonFunction {
  ConcreteMaybeNonFunction() { this = this }
}

deprecated private class ConcreteMaybeFromProto extends MaybeFromProto {
  ConcreteMaybeFromProto() { this = this }
}

/** Gets a data flow node referring to an instance of `Map`. */
private DataFlow::SourceNode mapObject(DataFlow::TypeTracker t) {
  t.start() and
  result = DataFlow::globalVarRef("Map").getAnInstantiation()
  or
  exists(DataFlow::TypeTracker t2 | result = mapObject(t2).track(t2, t))
}

/** Gets a data flow node referring to an instance of `Map`. */
private DataFlow::SourceNode mapObject() { result = mapObject(DataFlow::TypeTracker::end()) }

/**
 * A taint-tracking configuration for reasoning about unvalidated dynamic method calls.
 */
module UnvalidatedDynamicMethodCallConfig implements DataFlow::StateConfigSig {
  class FlowState = UnvalidatedDynamicMethodCall::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.(Source).getAFlowState() = state
  }

  predicate isSink(DataFlow::Node sink, FlowState state) { sink.(Sink).getAFlowState() = state }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    node.(Sanitizer).getAFlowState() = state
    or
    TaintTracking::defaultSanitizer(node) and
    state = FlowState::taint()
    or
    node = DataFlow::MakeStateBarrierGuard<FlowState, BarrierGuard>::getABarrierNode(state)
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    exists(DataFlow::PropRead read |
      node1 = read.getPropertyNameExpr().flow() and
      node2 = read and
      state1 = FlowState::taint() and
      (
        state2 = FlowState::maybeNonFunction()
        or
        // a property of `Object.create(null)` cannot come from a prototype
        not PropertyInjection::isPrototypeLessObject(read.getBase().getALocalSource()) and
        state2 = FlowState::maybeFromProto()
      ) and
      // avoid overlapping results with unsafe dynamic method access query
      not PropertyInjection::hasUnsafeMethods(read.getBase().getALocalSource())
    )
    or
    exists(DataFlow::CallNode get |
      get = mapObject().getAMethodCall("get") and
      get.getNumArgument() = 1 and
      node1 = get.getArgument(0) and
      node2 = get
    ) and
    state1 = FlowState::taint() and
    state2 = FlowState::maybeNonFunction()
    or
    state1 = FlowState::taint() and
    TaintTracking::defaultTaintStep(node1, node2) and
    state1 = state2
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about unvalidated dynamic method calls.
 */
module UnvalidatedDynamicMethodCallFlow =
  DataFlow::GlobalWithState<UnvalidatedDynamicMethodCallConfig>;

/**
 * DEPRECATED. Use the `UnvalidatedDynamicMethodCallFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnvalidatedDynamicMethodCall" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getFlowLabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getFlowLabel() = label
  }

  override predicate isLabeledBarrier(DataFlow::Node node, DataFlow::FlowLabel label) {
    super.isLabeledBarrier(node, label)
    or
    node.(Sanitizer).getFlowLabel() = label
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof NumberGuard or
    guard instanceof FunctionCheck
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    UnvalidatedDynamicMethodCallConfig::isAdditionalFlowStep(src,
      FlowState::fromFlowLabel(srclabel), dst, FlowState::fromFlowLabel(dstlabel))
  }
}
