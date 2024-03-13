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
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getAFlowLabel() = label
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof Sink and label = TaintedObject::label()
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowLabel label) {
    TaintTracking::defaultSanitizer(node) and
    label.isTaint()
    or
    node = TaintedObject::SanitizerGuard::getABarrierNode(label)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::FlowLabel inlbl, DataFlow::Node trg, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
    or
    // We're not using a taint-tracking config because taint steps would then apply to all flow states.
    // So we use a plain data flow config and manually add the default taint steps.
    inlbl.isTaint() and
    TaintTracking::defaultTaintStep(src, trg) and
    inlbl = outlbl
  }
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
