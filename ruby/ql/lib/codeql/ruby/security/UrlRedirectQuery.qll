/**
 * Provides a taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UrlRedirectConfig` is needed, otherwise
 * `UrlRedirectCustomizations` should be imported instead.
 */

private import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import UrlRedirectCustomizations
import UrlRedirectCustomizations::UrlRedirect

/**
 * A taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 * DEPRECATED: Use `UrlRedirectFlow`
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UrlRedirect" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    UrlRedirect::isAdditionalTaintStep(node1, node2)
  }
}

private module UrlRedirectConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    UrlRedirect::isAdditionalTaintStep(node1, node2)
  }
}

/**
 * Taint-tracking for detecting "URL redirection" vulnerabilities.
 */
module UrlRedirectFlow = TaintTracking::Global<UrlRedirectConfig>;
