/**
 * Provides a taint-tracking configuration for detecting "code execution from deserialization" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDeserialization::Configuration` is needed, otherwise
 * `UnsafeDeserializationCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import UnsafeDeserializationCustomizations::UnsafeDeserialization

/**
 * A taint-tracking configuration for detecting "code execution from deserialization" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeDeserialization" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }
}
