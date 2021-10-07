/**
 * Provides a taint-tracking configuration for reasoning about
 * safe flow from URLs.
 *
 * Note, for performance reasons: only import this file if
 * `SafeUrlFlow::Configuration` is needed, otherwise
 * `SafeUrlFlowCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint-tracking configuration for reasoning about
 * safe flow from URLs.
 */
module SafeUrlFlow {
  import SafeUrlFlowCustomizations::SafeUrlFlow

  /**
   * A taint-tracking configuration for reasoning about safe URLs.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SafeUrlFlow" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

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
