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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "StackTraceExposure" }

  override predicate isSource(DataFlow::Node src) { src instanceof Source }

  override predicate isSanitizer(DataFlow::Node nd) {
    super.isSanitizer(nd)
    or
    // read of a property other than `stack`
    nd.(DataFlow::PropRead).getPropertyName() != "stack"
    or
    // `toString` does not include the stack trace
    nd.(DataFlow::MethodCallNode).getMethodName() = "toString"
    or
    nd = StringConcatenation::getAnOperand(_)
  }

  override predicate isSink(DataFlow::Node snk) { snk instanceof Sink }
}
