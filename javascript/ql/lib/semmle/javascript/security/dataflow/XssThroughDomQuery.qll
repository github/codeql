/**
 * Provides a taint-tracking configuration for reasoning about
 * cross-site scripting vulnerabilities through the DOM.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
import Xss::XssThroughDom
private import XssThroughDomCustomizations::XssThroughDom
private import semmle.javascript.security.dataflow.Xss::DomBasedXss as DomBasedXss
private import semmle.javascript.security.dataflow.UnsafeJQueryPluginCustomizations::UnsafeJQueryPlugin as UnsafeJQuery

/**
 * A taint-tracking configuration for reasoning about XSS through the DOM.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "XssThroughDOM" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof DomBasedXss::Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof DomBasedXss::Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TypeTestGuard or
    guard instanceof UnsafeJQuery::PropertyPresenceSanitizer or
    guard instanceof DomBasedXss::SanitizerGuard
  }

  override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    DomBasedXss::isOptionallySanitizedEdge(pred, succ)
  }
}
