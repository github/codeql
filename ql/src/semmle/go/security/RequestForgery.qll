/**
 * Provides a taint-tracking configuration for reasoning about request forgery
 * (SSRF) vulnerabilities.
 */

import go
import OpenUrlRedirectCustomizations

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

  /**
   * A data-flow configuration for reasoning about safe URLs for request forgery.
   */
  class SafeUrlConfiguration extends TaintTracking::Configuration {
    SafeUrlConfiguration() { this = "SafeUrlFlow" }

    override predicate isSource(DataFlow::Node source) {
      source.(DataFlow::FieldReadNode).getField().hasQualifiedName("net/http", "Request", "URL")
      or
      source.(DataFlow::FieldReadNode).getField().hasQualifiedName("net/http", "Request", "Host")
    }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      // propagate to a URL when its host is assigned to
      exists(Write w, Field f, SsaWithFields v | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(v.getAUse(), f, pred) and succ = v.getAUse()
      )
    }

    override predicate isSanitizerOut(DataFlow::Node node) {
      // block propagation of this safe value when its host is overwritten
      exists(Write w, Field f | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(node.getASuccessor(), f, _)
      )
      or
      exists(DataFlow::FieldReadNode frn, string name |
        (name = "RawQuery" or name = "Fragment" or name = "User") and
        frn.getField().hasQualifiedName("net/url", "URL")
      |
        node = frn.getBase()
      )
      or
      TaintTracking::functionModelStep(any(OpenUrlRedirect::UnsafeUrlMethod um), node, _)
    }
  }
}
