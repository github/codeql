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
class Configuration extends TaintTracking::Configuration {
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

  override predicate isSanitizerEdge(DataFlow::Node source, DataFlow::Node sink) {
    sanitizingPrefixEdge(source, sink)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    isAdditionalRequestForgeryStep(pred, succ)
  }
}
