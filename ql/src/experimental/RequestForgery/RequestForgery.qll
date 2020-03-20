/**
 * Provides a taint-tracking configuration for reasoning about request forgery
 * (SSRF) vulnerabilities.
 */

import go

module RequestForgery {
  import RequestForgeryCustomizations::RequestForgery

  /**
   * A taint-tracking configuration for reasoning about request forgery.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "RequestForgery" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerOut(DataFlow::Node node) {
      super.isSanitizerOut(node) or
      node instanceof SanitizerEdge
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      super.isSanitizerGuard(guard) or guard instanceof SanitizerGuard
    }
  }
}
