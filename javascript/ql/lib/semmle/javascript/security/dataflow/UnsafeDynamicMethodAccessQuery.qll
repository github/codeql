/**
 * Provides a taint-tracking configuration for reasoning about method invocations
 * with a user-controlled method name on objects with unsafe methods.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDynamicMethodAccess::Configuration` is needed, otherwise
 * `UnsafeDynamicMethodAccessCustomizations` should be imported instead.
 */

import javascript
import PropertyInjectionShared
import UnsafeDynamicMethodAccessCustomizations::UnsafeDynamicMethodAccess
private import UnsafeDynamicMethodAccessCustomizations::UnsafeDynamicMethodAccess as UnsafeDynamicMethodAccess

// Materialize flow labels
deprecated private class ConcreteUnsafeFunction extends UnsafeFunction {
  ConcreteUnsafeFunction() { this = this }
}

/**
 * A taint-tracking configuration for reasoning about unsafe dynamic method access.
 */
module UnsafeDynamicMethodAccessConfig implements DataFlow::StateConfigSig {
  class FlowState = UnsafeDynamicMethodAccess::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.(Source).getAFlowState() = state
  }

  predicate isSink(DataFlow::Node sink, FlowState state) { sink.(Sink).getAFlowState() = state }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer
    or
    exists(StringConcatenation::getOperand(node, _)) and
    not StringConcatenation::isCoercion(node)
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    TaintTracking::defaultSanitizer(node) and
    state = FlowState::taint()
  }

  /** An additional flow step for use in both this configuration and the legacy configuration. */
  additional predicate additionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    // Reading a property of the global object or of a function
    exists(DataFlow::PropRead read |
      PropertyInjection::hasUnsafeMethods(read.getBase().getALocalSource()) and
      node1 = read.getPropertyNameExpr().flow() and
      node2 = read and
      state1 = FlowState::taint() and
      state2 = FlowState::unsafeFunction()
    )
    or
    // Reading a chain of properties from any object with a prototype can lead to Function
    exists(PropertyProjection proj |
      not PropertyInjection::isPrototypeLessObject(proj.getObject().getALocalSource()) and
      node1 = proj.getASelector() and
      node2 = proj and
      state1 = FlowState::taint() and
      state2 = FlowState::unsafeFunction()
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    additionalFlowStep(node1, state1, node2, state2)
    or
    // We're not using a taint-tracking config because taint steps would then apply to all flow states.
    // So we use a plain data flow config and manually add the default taint steps.
    state1 = FlowState::taint() and
    TaintTracking::defaultTaintStep(node1, node2) and
    state1 = state2
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about unsafe dynamic method access.
 */
module UnsafeDynamicMethodAccessFlow = DataFlow::GlobalWithState<UnsafeDynamicMethodAccessConfig>;

/**
 * DEPRECATED. Use the `UnsafeDynamicMethodAccessFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeDynamicMethodAccess" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    UnsafeDynamicMethodAccessConfig::isSource(source, FlowState::fromFlowLabel(label))
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    UnsafeDynamicMethodAccessConfig::isSink(sink, FlowState::fromFlowLabel(label))
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    UnsafeDynamicMethodAccessConfig::isBarrier(node)
  }

  /**
   * Holds if a property of the given object is an unsafe function.
   */
  predicate hasUnsafeMethods(DataFlow::SourceNode node) {
    PropertyInjection::hasUnsafeMethods(node) // Redefined here so custom queries can override it
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    UnsafeDynamicMethodAccessConfig::additionalFlowStep(src, FlowState::fromFlowLabel(srclabel),
      dst, FlowState::fromFlowLabel(dstlabel))
  }
}
