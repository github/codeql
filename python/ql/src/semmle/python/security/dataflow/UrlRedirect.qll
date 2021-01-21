/**
 * Provides a taint-tracking configuration for detecting URL redirection
 * vulnerabilities.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.BarrierGuards

/**
 * A taint-tracking configuration for detecting URL redirection vulnerabilities.
 */
class UrlRedirectConfiguration extends TaintTracking::Configuration {
  UrlRedirectConfiguration() { this = "UrlRedirectConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(HTTP::Server::HttpRedirectResponse e).getRedirectLocation()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    // Url redirection is a problem only if the user controls the prefix of the URL.
    // TODO: This is a copy of the taint-sanitizer from the old points-to query, which doesn't
    // cover formatting.
    exists(BinaryExprNode string_concat | string_concat.getOp() instanceof Add |
      string_concat.getRight() = node.asCfgNode()
    )
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StringConstCompare
  }
}
