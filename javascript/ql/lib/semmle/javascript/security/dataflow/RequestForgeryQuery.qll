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

/**
 * DEPRECATED. Use the `RequestForgeryFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "RequestForgery" }

  override predicate isSource(DataFlow::Node source) { RequestForgeryConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { RequestForgeryConfig::isSink(sink) }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    node instanceof Sanitizer
  }

  override predicate isSanitizerOut(DataFlow::Node node) {
    RequestForgeryConfig::isBarrierOut(node)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    RequestForgeryConfig::isAdditionalFlowStep(pred, succ)
  }
}
