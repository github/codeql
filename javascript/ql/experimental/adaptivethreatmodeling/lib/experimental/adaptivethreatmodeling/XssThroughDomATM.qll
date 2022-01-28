/**
 * Provides a taint-tracking configuration for reasoning about
 * cross-site scripting vulnerabilities through the DOM.
 * Is boosted by ATM.
 */

import javascript
import AdaptiveThreatModeling
private import semmle.javascript.dataflow.InferredTypes
import semmle.javascript.security.dataflow.Xss::XssThroughDom
private import semmle.javascript.security.dataflow.XssThroughDomCustomizations::XssThroughDom
private import semmle.javascript.security.dataflow.Xss::DomBasedXss as DomBasedXss
private import semmle.javascript.security.dataflow.UnsafeJQueryPluginCustomizations::UnsafeJQueryPlugin as UnsafeJQuery

/**
 * This module provides logic to filter candidate sinks to those which are likely XSS sinks.
 */
module SinkEndpointFilter {
  private import StandardEndpointFilters as StandardEndpointFilters

  /**
   * Provides a set of reasons why a given data flow node should be excluded as a sink candidate.
   *
   * If this predicate has no results for a sink candidate `n`, then we should treat `n` as an
   * effective sink.
   */
  string getAReasonSinkExcluded(DataFlow::Node sinkCandidate) {
    result = StandardEndpointFilters::getAReasonSinkExcluded(sinkCandidate)
  }
}

class XssThroughDOMATMConfig extends ATMConfig {
  XssThroughDOMATMConfig() { this = "XssThroughDOMATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof Source }

  override predicate isKnownSink(DataFlow::Node sink) { sink instanceof DomBasedXss::Sink }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    not exists(SinkEndpointFilter::getAReasonSinkExcluded(sinkCandidate))
  }

  override EndpointType getASinkEndpointType() { result instanceof XssSinkType }
}

/**
 * A taint-tracking configuration for reasoning about XSS through the DOM.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "XssThroughDOMATMConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) {
    (sink instanceof DomBasedXss::Sink or any(XssThroughDOMATMConfig cfg).isEffectiveSink(sink))
  }

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
