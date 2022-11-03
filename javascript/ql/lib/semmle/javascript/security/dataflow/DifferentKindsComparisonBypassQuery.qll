/**
 * Provides classes for reasoning about comparisons that relies on
 * different kinds of HTTP request data.
 *
 * Note, for performance reasons: only import this file if
 * `DifferentKindsComparisonBypass::Configuration` is needed,
 * otherwise `DifferentKindsComparisonBypassCustomizations` should be
 * imported instead.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources
import DifferentKindsComparisonBypassCustomizations::DifferentKindsComparisonBypass

/**
 * A taint tracking configuration for comparisons that relies on different kinds of HTTP request data.
 */
private class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "DifferentKindsComparisonBypass" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}

/**
 * A comparison that relies on different kinds of HTTP request data.
 */
class DifferentKindsComparison extends Comparison {
  Source lSource;
  Source rSource;

  DifferentKindsComparison() {
    exists(Configuration cfg |
      cfg.hasFlow(lSource, DataFlow::valueNode(getLeftOperand())) and
      cfg.hasFlow(rSource, DataFlow::valueNode(getRightOperand())) and
      lSource.isSuspiciousToCompareWith(rSource)
    )
  }

  /** Gets the left operand source of this comparison. */
  Source getLSource() { result = lSource }

  /** Gets the right operand source of this comparison. */
  Source getRSource() { result = rSource }
}
