/**
 * Provides a taint tracking configuration for reasoning about bypass of sensitive action guards.
 *
 * Note, for performance reasons: only import this file if
 * `ConditionalBypass::Configuration` is needed, otherwise
 * `ConditionalBypassCustomizations` should be imported instead.
 */

import javascript
private import semmle.javascript.security.SensitiveActions
import ConditionalBypassCustomizations::ConditionalBypass

/**
 * A taint tracking configuration for bypass of sensitive action guards.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ConditionalBypass" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node dst) {
    // comparing a tainted expression against a constant gives a tainted result
    dst.asExpr().(Comparison).hasOperands(src.asExpr(), any(ConstantExpr c))
  }
}
