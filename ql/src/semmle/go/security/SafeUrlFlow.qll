/**
 * Provides a taint-tracking configuration for reasoning about
 * safe flow from URLs.
 *
 * Note, for performance reasons: only import this file if
 * `OpenUrlRedirect::Configuration` is needed, otherwise
 * `OpenUrlRedirectCustomizations` should be imported instead.
 */

import go

module SafeUrlFlow {
  import SafeUrlFlowCustomizations::SafeUrlFlow

  /**
   * A data-flow configuration for reasoning about safe URLs.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SafeUrlFlow" }

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
      node instanceof SanitizerEdge
    }
  }
}
