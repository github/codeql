/**
 * Provides a taint-tracking configuration for detecting "stack trace exposure" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `StackTraceExposure::Configuration` is needed, otherwise
 * `StackTraceExposureCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import StackTraceExposureCustomizations::StackTraceExposure

/**
 * A taint-tracking configuration for detecting "stack trace exposure" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "StackTraceExposure" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }

  // A stack trace is accessible as the `__traceback__` attribute of a caught exception.
  //  seehttps://docs.python.org/3/reference/datamodel.html#traceback-objects
  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(DataFlow::AttrRead attr | attr.getAttributeName() = "__traceback__" |
      nodeFrom = attr.getObject() and
      nodeTo = attr
    )
  }
}
