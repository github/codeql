/**
 * Provides a taint-tracking configuration for reasoning about
 * template object injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `TemplateObjectInjection::Configuration` is needed, otherwise
 * `TemplateObjectInjectionCustomizations` should be imported instead.
 */

import javascript
import TemplateObjectInjectionCustomizations::TemplateObjectInjection
private import semmle.javascript.security.TaintedObject

/**
 * A taint tracking configuration for reasoning about template object injection vulnerabilities.
 */
module TemplateObjectInjectionConfig implements DataFlow::StateConfigSig {
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.(Source).getAFlowState() = state
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof Sink and state.isTaintedObject()
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    TaintTracking::defaultSanitizer(node) and
    state.isTaint()
    or
    node = TaintedObject::SanitizerGuard::getABarrierNode(state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedObject::isAdditionalFlowStep(node1, state1, node2, state2)
    or
    // We're not using a taint-tracking config because taint steps would then apply to all flow states.
    // So we use a plain data flow config and manually add the default taint steps.
    state1.isTaint() and
    TaintTracking::defaultTaintStep(node1, node2) and
    state1 = state2
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint tracking for reasoning about template object injection vulnerabilities.
 */
module TemplateObjectInjectionFlow = DataFlow::GlobalWithState<TemplateObjectInjectionConfig>;

/**
 * DEPRECATED. Use the `TemplateObjectInjectionFlow` module instead.
 */
deprecated class TemplateObjInjectionConfig extends TaintTracking::Configuration {
  TemplateObjInjectionConfig() { this = "TemplateObjInjectionConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getAFlowLabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof Sink and label = TaintedObject::label()
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
  }
}
