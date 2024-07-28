/**
 * Provides a taint-tracking configuration for reasoning about stored
 * cross-site scripting vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `StoredXss::Configuration` is needed, otherwise
 * `StoredXssCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint-tracking configuration for reasoning about stored
 * cross-site scripting vulnerabilities.
 */
module StoredXss {
  import StoredXssCustomizations::StoredXss

  /**
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-tracking configuration for reasoning about XSS.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "StoredXss" }

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

  /** Tracks taint flow for reasoning about XSS. */
  module Flow = TaintTracking::Global<Config>;
}
