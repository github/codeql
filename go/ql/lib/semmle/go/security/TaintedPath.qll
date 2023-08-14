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
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-tracking configuration for reasoning about path-traversal vulnerabilities.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "TaintedPath" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** Tracks taint flow for reasoning about path-traversal vulnerabilities. */
  module Flow = TaintTracking::Global<Config>;
}
