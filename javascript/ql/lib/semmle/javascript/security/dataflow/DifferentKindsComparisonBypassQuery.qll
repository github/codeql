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
import DifferentKindsComparisonBypassCustomizations::DifferentKindsComparisonBypass

/**
 * A taint tracking configuration for comparisons that relies on different kinds of HTTP request data.
 */
private module DifferentKindsComparisonBypassConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() {
    none() // Disabled since multiple related sinks are selected simultaneously
  }
}

/**
 * Taint tracking for comparisons that relies on different kinds of HTTP request data.
 */
private module DifferentKindsComparisonBypassFlow =
  TaintTracking::Global<DifferentKindsComparisonBypassConfig>;

/**
 * A comparison that relies on different kinds of HTTP request data.
 */
class DifferentKindsComparison extends Comparison {
  Source lSource;
  Source rSource;

  DifferentKindsComparison() {
    DifferentKindsComparisonBypassFlow::flow(lSource, DataFlow::valueNode(this.getLeftOperand())) and
    DifferentKindsComparisonBypassFlow::flow(rSource, DataFlow::valueNode(this.getRightOperand())) and
    lSource.isSuspiciousToCompareWith(rSource)
  }

  /** Gets the left operand source of this comparison. */
  Source getLSource() { result = lSource }

  /** Gets the right operand source of this comparison. */
  Source getRSource() { result = rSource }
}
