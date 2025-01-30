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

private module UrlRedirectConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    UrlRedirect::isAdditionalTaintStep(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting "URL redirection" vulnerabilities.
 */
module UrlRedirectFlow = TaintTracking::Global<UrlRedirectConfig>;
