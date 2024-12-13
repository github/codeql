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
private import DataFlow::FlowLabel
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

  predicate isSource(DataFlow::Node source, FlowState label) {
    source.(Source).getAFlowState() = label
  }

  predicate isSink(DataFlow::Node sink, FlowState label) { sink.(Sink).getAFlowState() = label }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer
    or
    exists(StringConcatenation::getOperand(node, _)) and
    not StringConcatenation::isCoercion(node)
  }

  predicate isBarrier(DataFlow::Node node, FlowState label) {
    TaintTracking::defaultSanitizer(node) and
    label = FlowState::taint()
  }

  /** An additional flow step for use in both this configuration and the legacy configuration. */
  additional predicate additionalFlowStep(
    DataFlow::Node src, FlowState srclabel, DataFlow::Node dst, FlowState dstlabel
  ) {
    // Reading a property of the global object or of a function
    exists(DataFlow::PropRead read |
      PropertyInjection::hasUnsafeMethods(read.getBase().getALocalSource()) and
      src = read.getPropertyNameExpr().flow() and
      dst = read and
      srclabel = FlowState::taint() and
      dstlabel = FlowState::unsafeFunction()
    )
    or
    // Reading a chain of properties from any object with a prototype can lead to Function
    exists(PropertyProjection proj |
      not PropertyInjection::isPrototypeLessObject(proj.getObject().getALocalSource()) and
      src = proj.getASelector() and
      dst = proj and
      srclabel = FlowState::taint() and
      dstlabel = FlowState::unsafeFunction()
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node src, FlowState srclabel, DataFlow::Node dst, FlowState dstlabel
  ) {
    additionalFlowStep(src, srclabel, dst, dstlabel)
    or
    // We're not using a taint-tracking config because taint steps would then apply to all flow states.
    // So we use a plain data flow config and manually add the default taint steps.
    srclabel = FlowState::taint() and
    TaintTracking::defaultTaintStep(src, dst) and
    srclabel = dstlabel
  }
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
