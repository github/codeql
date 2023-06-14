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
module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  additional deprecated predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }
}
