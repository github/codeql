/**
 * Provides a taint-tracking configuration for reasoning about client-side
 * request forgery.
 *
 * Note, for performance reasons: only import this file if
 * the `Configuration` class is needed, otherwise
 * `RequestForgeryCustomizations` should be imported instead.
 */

import javascript
import UrlConcatenation
import RequestForgeryCustomizations::RequestForgery

/**
 * A taint tracking configuration for client-side request forgery.
 */
module ClientSideRequestForgeryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Source src |
      source = src and
      not src.isServerSide()
    )
  }

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
 * Taint tracking for client-side request forgery.
 */
module ClientSideRequestForgeryFlow = TaintTracking::Global<ClientSideRequestForgeryConfig>;

/**
 * DEPRECATED. Use the `ClientSideRequestForgeryFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ClientSideRequestForgery" }

  override predicate isSource(DataFlow::Node source) {
    exists(Source src |
      source = src and
      not src.isServerSide()
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isSanitizerOut(DataFlow::Node node) { sanitizingPrefixEdge(node, _) }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    isAdditionalRequestForgeryStep(pred, succ)
  }
}
