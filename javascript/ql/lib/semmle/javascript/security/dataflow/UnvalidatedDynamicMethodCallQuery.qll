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

/**
 * A taint-tracking configuration for reasoning about unvalidated dynamic method calls.
 */
module UnvalidatedDynamicMethodCallConfig implements DataFlow::StateConfigSig {
  class FlowState = UnvalidatedDynamicMethodCall::FlowState;

  predicate isSource(DataFlow::Node source, FlowState label) {
    source.(Source).getAFlowState() = label
  }

  predicate isSink(DataFlow::Node sink, FlowState label) { sink.(Sink).getAFlowState() = label }

  predicate isBarrier(DataFlow::Node node, FlowState label) {
    node.(Sanitizer).getAFlowState() = label
    or
    TaintTracking::defaultSanitizer(node) and
    label = FlowState::taint()
    or
    node = DataFlow::MakeStateBarrierGuard<FlowState, BarrierGuard>::getABarrierNode(label)
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node src, FlowState srclabel, DataFlow::Node dst, FlowState dstlabel
  ) {
    exists(DataFlow::PropRead read |
      src = read.getPropertyNameExpr().flow() and
      dst = read and
      srclabel = FlowState::taint() and
      (
        dstlabel = FlowState::maybeNonFunction()
        or
        // a property of `Object.create(null)` cannot come from a prototype
        not PropertyInjection::isPrototypeLessObject(read.getBase().getALocalSource()) and
        dstlabel = FlowState::maybeFromProto()
      ) and
      // avoid overlapping results with unsafe dynamic method access query
      not PropertyInjection::hasUnsafeMethods(read.getBase().getALocalSource())
    )
    or
    exists(DataFlow::SourceNode base, DataFlow::CallNode get | get = base.getAMethodCall("get") |
      src = get.getArgument(0) and
      dst = get
    ) and
    srclabel = FlowState::taint() and
    dstlabel = FlowState::maybeNonFunction()
    or
    srclabel = FlowState::taint() and
    TaintTracking::defaultTaintStep(src, dst) and
    srclabel = dstlabel
  }
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
