/**
 * Provides a taint-tracking configuration for reasoning about request
 * forgery.
 *
 * Note, for performance reasons: only import this file if
 * `RequestForgery::Configuration` is needed, otherwise
 * `RequestForgeryCustomizations` should be imported instead.
 */

import javascript
import UrlConcatenation
import RequestForgeryCustomizations::RequestForgery

/**
 * A taint tracking configuration for server-side request forgery.
 */
module RequestForgeryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.(Source).isServerSide() }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isBarrierOut(DataFlow::Node node) { sanitizingPrefixEdge(node, _) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalRequestForgeryStep(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getARequest().getLocation()
  }
}

/**
 * Taint tracking for server-side request forgery.
 */
module RequestForgeryFlow = TaintTracking::Global<RequestForgeryConfig>;
