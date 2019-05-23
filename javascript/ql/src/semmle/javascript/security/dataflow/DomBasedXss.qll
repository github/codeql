/**
 * Provides a taint-tracking configuration for reasoning about DOM-based
 * cross-site scripting vulnerabilities.
 */

import javascript

module DomBasedXss {
  import Xss::DomBasedXss

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

  /** A source of remote user input, considered as a flow source for DOM-based XSS. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An access of the URL of this page, or of the referrer to this page.
   */
  class LocationSource extends Source {
    LocationSource() { this = DOM::locationSource() }
  }
}
