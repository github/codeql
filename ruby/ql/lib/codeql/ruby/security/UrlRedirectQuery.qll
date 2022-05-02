/**
 * Provides a taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if `Configuration` is needed,
 * otherwise `UrlRedirectCustomizations` should be imported instead.
 */

private import ruby
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import UrlRedirectCustomizations
import UrlRedirectCustomizations::UrlRedirect

/**
 * A taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UrlRedirect" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    UrlRedirect::isAdditionalTaintStep(node1, node2)
  }
}
