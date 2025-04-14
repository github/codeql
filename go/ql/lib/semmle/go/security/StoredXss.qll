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

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** Tracks taint flow for reasoning about XSS. */
  module Flow = TaintTracking::Global<Config>;
}
