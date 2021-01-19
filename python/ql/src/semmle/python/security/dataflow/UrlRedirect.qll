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

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StringConstCompare
  }
}
