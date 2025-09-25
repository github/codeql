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

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      // propagate to a URL when its host is assigned to
      exists(Write w, Field f, SsaWithFields v | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesFieldPreUpdate(v.getAUse(), f, node1) and
        node2 = v.getAUse()
      )
    }

    predicate isBarrierOut(DataFlow::Node node) {
      // block propagation of this safe value when its host is overwritten
      exists(Write w, DataFlow::Node base, Field f | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(base, f, _) and
        [base, base.(DataFlow::PostUpdateNode).getPreUpdateNode()] = node.getASuccessor()
      )
      or
      node instanceof SanitizerEdge
    }

    predicate observeDiffInformedIncrementalMode() {
      none() // only used as secondary configuration
    }
  }

  /** Tracks taint flow for reasoning about safe URLs. */
  module Flow = TaintTracking::Global<Config>;
}
