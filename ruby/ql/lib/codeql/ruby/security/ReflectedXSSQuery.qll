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

private module ReflectedXssConfig implements DataFlow::ConfigSig {
  private import XSS::ReflectedXss as RX

  predicate isSource(DataFlow::Node source) { source instanceof RX::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof RX::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof RX::Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    RX::isAdditionalXssTaintStep(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting "reflected server-side cross-site scripting" vulnerabilities.
 */
module ReflectedXssFlow = TaintTracking::Global<ReflectedXssConfig>;
