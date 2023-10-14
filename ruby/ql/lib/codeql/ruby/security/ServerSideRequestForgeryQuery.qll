/**
 * Provides a taint-tracking configuration for detecting
 * "Server side request forgery" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `ServerSideRequestForgeryFlow` is needed, otherwise
 * `ServerSideRequestForgeryCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import ServerSideRequestForgeryCustomizations::ServerSideRequestForgery
import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for detecting
 * "Server side request forgery" vulnerabilities.
 * DEPRECATED: Use `ServerSideRequestForgeryFlow`
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ServerSideRequestForgery" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof Sanitizer or
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }
}

private module ServerSideRequestForgeryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }
}

/**
 * Taint-tracking for detecting "Server side request forgery" vulnerabilities.
 */
module ServerSideRequestForgeryFlow = TaintTracking::Global<ServerSideRequestForgeryConfig>;
