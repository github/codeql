/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `ReflectedXSS::Configuration` is needed, otherwise
 * `ReflectedXSSCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import ReflectedXSSCustomizations::ReflectedXss

/**
 * A taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ReflectedXSS" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }
}
