/**
 * Provides a taint-tracking configuration for detecting
 * "Server side request forgery" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if `Configuration` is needed,
 * otherwise `ServerSideRequestForgeryCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import ServerSideRequestForgeryCustomizations::ServerSideRequestForgery
import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for detecting
 * "Server side request forgery" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ServerSideRequestForgery" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard or
    guard instanceof StringConstCompare or
    guard instanceof StringConstArrayInclusionCall
  }
}
