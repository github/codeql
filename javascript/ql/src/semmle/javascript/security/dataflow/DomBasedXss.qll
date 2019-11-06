/**
 * Provides a taint-tracking configuration for reasoning about DOM-based
 * cross-site scripting vulnerabilities.
 */

import javascript

module DomBasedXss {
  import DomBasedXssCustomizations::DomBasedXss

  /**
   * A taint-tracking configuration for reasoning about XSS.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "DomBasedXss" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node)
      or
      exists(PropAccess pacc | pacc = node.asExpr() |
        isSafeLocationProperty(pacc)
        or
        // `$(location.hash)` is a fairly common and safe idiom
        // (because `location.hash` always starts with `#`),
        // so we mark `hash` as safe for the purposes of this query
        pacc.getPropertyName() = "hash"
      )
      or
      node instanceof Sanitizer
    }
  }
}
