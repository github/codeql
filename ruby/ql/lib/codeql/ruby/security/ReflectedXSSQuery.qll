/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `ReflectedXSS::Configuration` is needed, otherwise
 * `XSS::ReflectedXSS` should be imported instead.
 */

private import ruby
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 */
module ReflectedXss {
  import XSS::ReflectedXss

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

    override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
      isAdditionalXssTaintStep(node1, node2)
    }
  }
}

/** DEPRECATED: Alias for ReflectedXss */
deprecated module ReflectedXSS = ReflectedXss;
