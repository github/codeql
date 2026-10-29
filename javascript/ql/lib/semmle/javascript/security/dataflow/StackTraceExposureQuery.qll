/**
 * Provides a taint-tracking configuration for reasoning about stack
 * trace exposure problems.
 *
 * Note, for performance reasons: only import this file if
 * `StackTraceExposure::Configuration` is needed, otherwise
 * `StackTraceExposureCustomizations` should be imported instead.
 */

import javascript
import StackTraceExposureCustomizations::StackTraceExposure

/**
 * A taint-tracking configuration for reasoning about stack trace
 * exposure problems.
 */
module StackTraceExposureConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof Source }

  predicate isBarrier(DataFlow::Node nd) {
    // read of a property other than `stack`
    nd.(DataFlow::PropRead).getPropertyName() != "stack"
    or
    // `toString` does not include the stack trace
    nd.(DataFlow::MethodCallNode).getMethodName() = "toString"
    or
    nd = StringConcatenation::getAnOperand(_)
  }

  predicate isSink(DataFlow::Node snk) { snk instanceof Sink }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about stack trace exposure problems.
 */
module StackTraceExposureFlow = TaintTracking::Global<StackTraceExposureConfig>;

/**
 * DEPRECATED. Use the `StackTraceExposureFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "StackTraceExposure" }

  override predicate isSource(DataFlow::Node src) { src instanceof Source }

  override predicate isSanitizer(DataFlow::Node nd) {
    super.isSanitizer(nd)
    or
    StackTraceExposureConfig::isBarrier(nd)
  }

  override predicate isSink(DataFlow::Node snk) { snk instanceof Sink }
}
