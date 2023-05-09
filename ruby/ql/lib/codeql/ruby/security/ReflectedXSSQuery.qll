/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `ReflectedXSS::Configuration` is needed, otherwise
 * `XSS::ReflectedXSS` should be imported instead.
 */

private import codeql.ruby.AST
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
  module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

  private module ConfigurationImpl implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    additional deprecated predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      isAdditionalXssTaintStep(node1, node2)
    }
  }
}

/** DEPRECATED: Alias for ReflectedXss */
deprecated module ReflectedXSS = ReflectedXss;
