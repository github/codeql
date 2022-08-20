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
class TemplateObjInjectionConfig extends TaintTracking::Configuration {
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
