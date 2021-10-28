/**
 * Provides a taint-tracking configuration for reasoning about request forgery
 * (SSRF) vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `RequestForgery::Configuration` is needed, otherwise
 * `RequestForgeryCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint-tracking configuration for reasoning about request forgery
 * (SSRF) vulnerabilities.
 */
module RequestForgery {
  import RequestForgeryCustomizations::RequestForgery

  /**
   * A taint-tracking configuration for reasoning about request forgery.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "RequestForgery" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      // propagate to a URL when its host is assigned to
      exists(Write w, Field f, SsaWithFields v | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(v.getAUse(), f, pred) and succ = v.getAUse()
      )
    }

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
