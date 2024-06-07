/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `ReflectedXssFlow` is needed, otherwise
 * `XSS::ReflectedXss` should be imported instead.
 */

private import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 * DEPRECATED: Use `ReflectedXssFlow`
 */
deprecated module ReflectedXss {
  import XSS::ReflectedXss

  /**
   * A taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
   * DEPRECATED: Use `ReflectedXssFlow`
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ReflectedXSS" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
      isAdditionalXssTaintStep(node1, node2)
    }
  }
}

private module ReflectedXssConfig implements DataFlow::ConfigSig {
  private import XSS::ReflectedXss as RX

  predicate isSource(DataFlow::Node source) { source instanceof RX::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof RX::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof RX::Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    RX::isAdditionalXssTaintStep(node1, node2)
  }
}

/**
 * Taint-tracking for detecting "reflected server-side cross-site scripting" vulnerabilities.
 */
module ReflectedXssFlow = TaintTracking::Global<ReflectedXssConfig>;
