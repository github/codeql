/**
 * Provides a taint-tracking configuration for tracking untrusted user input used in log entries.
 *
 * Note, for performance reasons: only import this file if
 * `LogInjection::Configuration` is needed, otherwise
 * `LogInjectionCustomizations` should be imported instead.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import LogInjectionCustomizations::LogInjection

/**
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "LogInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }
}
