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
      // propagate taint to the post-update node of a URL when its host is
      // assigned to
      exists(Write w, Field f | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(node2, f, node1)
      )
    }

    predicate isBarrierOut(DataFlow::Node node) {
      // block propagation of this safe value when its host is overwritten
      exists(Write w, Field f | f.hasQualifiedName("net/url", "URL", "Host") |
        // We sanitize the pre-update node to block flow from previous value.
        // This fits in with the additional flow step above propagating taint
        // from the value written to the Host field to the post-update node of
        // the URL.
        w.writesFieldPreUpdate(node, f, _)
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
