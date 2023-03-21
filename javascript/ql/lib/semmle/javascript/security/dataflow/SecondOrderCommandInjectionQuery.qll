/**
 * Provides a taint tracking configuration for reasoning about
 * second order command-injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `SecondOrderCommandInjection::Configuration` is needed, otherwise
 * `SecondOrderCommandInjectionCustomizations` should be imported instead.
 */

import javascript
import SecondOrderCommandInjectionCustomizations::SecondOrderCommandInjection
private import semmle.javascript.security.TaintedObject

/**
 * A taint-tracking configuration for reasoning about second order command-injection vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SecondOrderCommandInjection" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getALabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getALabel() = label
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof PrefixStringSanitizer or
    guard instanceof DoubleDashSanitizer or
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
  }
}
