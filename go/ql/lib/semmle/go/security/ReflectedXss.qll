/**
 * Provides a taint-tracking configuration for reasoning about reflected
 * cross-site scripting vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `ReflectedXss::Configuration` is needed, otherwise
 * `ReflectedXssCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint-tracking configuration for reasoning about reflected
 * cross-site scripting vulnerabilities.
 */
module ReflectedXss {
  import ReflectedXssCustomizations::ReflectedXss

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** Tracks taint flow from untrusted data to XSS attack vectors. */
  module Flow = TaintTracking::Global<Config>;
}
