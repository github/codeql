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
        w.writesField(v.getAUse(), f, node1) and node2 = v.getAUse()
      )
    }

    predicate isBarrierOut(DataFlow::Node node) {
      // block propagation of this safe value when its host is overwritten
      exists(Write w, Field f | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(node.getASuccessor(), f, _)
      )
      or
      node instanceof SanitizerEdge
    }

    predicate observeDiffInformedIncrementalMode() {
      // TODO(diff-informed): Manually verify if config can be diff-informed.
      // ql/src/Security/CWE-601/OpenUrlRedirect.ql:26: Column 5 does not select a source or sink originating from the flow call on line 24
      // ql/src/Security/CWE-918/RequestForgery.ql:25: Column 1 selects sink.getARequest
      // ql/src/Security/CWE-918/RequestForgery.ql:26: Column 7 does not select a source or sink originating from the flow call on line 24
      none()
    }
  }

  /** Tracks taint flow for reasoning about safe URLs. */
  module Flow = TaintTracking::Global<Config>;
}
