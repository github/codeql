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
 * A taint tracking configuration for request forgery.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "RequestForgery" }

  override predicate isSource(DataFlow::Node source) { source.(Source).isServerSide() }

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
