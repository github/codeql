/**
 * Provides a taint tracking configuration for reasoning about path-traversal vulnerabilities.
 *
 * Note: for performance reasons, only import this file if `TaintedPath::Configuration` is needed,
 * otherwise `TaintedPathCustomizations` should be imported instead.
 */

import go

/** Provides a taint tracking configuration for reasoning about path-traversal vulnerabilities. */
module TaintedPath {
  import TaintedPathCustomizations::TaintedPath

  /**
   * A taint-tracking configuration for reasoning about path-traversal vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "TaintedPath" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuardAsBarrierGuard
    }
  }
}
