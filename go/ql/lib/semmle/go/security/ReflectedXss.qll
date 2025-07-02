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

    predicate observeDiffInformedIncrementalMode() {
      any() // TODO: Make sure that the location overrides match the query's select clause: Column 7 selects sink.getAssociatedLoc (/Users/d10c/src/semmle-code/ql/go/ql/src/Security/CWE-079/ReflectedXss.ql@36:84:36:90)
    }
  }

  /** Tracks taint flow from untrusted data to XSS attack vectors. */
  module Flow = TaintTracking::Global<Config>;
}
