/**
 * Provides a taint-tracking configuration for reasoning about
 * cross-site scripting vulnerabilities through the DOM.
 * Is boosted by ATM.
 */

import javascript
import AdaptiveThreatModeling
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.security.dataflow.XssThroughDomCustomizations::XssThroughDom
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations
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

class XssThroughDomAtmConfig extends ATMConfig {
  XssThroughDomAtmConfig() { this = "XssThroughDomAtmConfig" }

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
  Configuration() { this = "XssThroughDomAtmConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) {
    (sink instanceof DomBasedXss::Sink or any(XssThroughDomAtmConfig cfg).isEffectiveSink(sink))
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof DomBasedXss::Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TypeTestGuard or
    guard instanceof UnsafeJQuery::PropertyPresenceSanitizer or
    guard instanceof UnsafeJQuery::NumberGuard or
    guard instanceof PrefixStringSanitizer or
    guard instanceof QuoteGuard or
    guard instanceof ContainsHtmlGuard
  }

  override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    DomBasedXss::isOptionallySanitizedEdge(pred, succ)
  }
}

/**
 * A test of form `typeof x === "something"`, preventing `x` from being a string in some cases.
 *
 * This sanitizer helps prune infeasible paths in type-overloaded functions.
 */
class TypeTestGuard extends TaintTracking::SanitizerGuardNode, DataFlow::ValueNode {
  override EqualityTest astNode;
  Expr operand;
  boolean polarity;

  TypeTestGuard() {
    exists(TypeofTag tag | TaintTracking::isTypeofGuard(astNode, operand, tag) |
      // typeof x === "string" sanitizes `x` when it evaluates to false
      tag = "string" and
      polarity = astNode.getPolarity().booleanNot()
      or
      // typeof x === "object" sanitizes `x` when it evaluates to true
      tag != "string" and
      polarity = astNode.getPolarity()
    )
  }

  override predicate sanitizes(boolean outcome, Expr e) {
    polarity = outcome and
    e = operand
  }
}

private import semmle.javascript.security.dataflow.Xss::Shared as Shared

private class PrefixStringSanitizer extends TaintTracking::SanitizerGuardNode,
  DomBasedXss::PrefixStringSanitizer {
  PrefixStringSanitizer() { this = this }
}

private class PrefixString extends DataFlow::FlowLabel, DomBasedXss::PrefixString {
  PrefixString() { this = this }
}

private class QuoteGuard extends TaintTracking::SanitizerGuardNode, Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends TaintTracking::SanitizerGuardNode, Shared::ContainsHtmlGuard {
  ContainsHtmlGuard() { this = this }
}
