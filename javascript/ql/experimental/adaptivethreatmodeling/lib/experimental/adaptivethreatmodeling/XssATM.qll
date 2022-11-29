/**
 * For internal use only.
 *
 * Defines shared code used by the XSS boosted query.
 */

private import semmle.javascript.heuristics.SyntacticHeuristics
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations
import AdaptiveThreatModeling
import CoreKnowledge as CoreKnowledge

class DomBasedXssAtmConfig extends AtmConfig {
  DomBasedXssAtmConfig() { this = "DomBasedXssATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof DomBasedXss::Source }

  override EndpointType getASinkEndpointType() { result instanceof XssSinkType }
}

/** DEPRECATED: Alias for DomBasedXssAtmConfig */
deprecated class DomBasedXssATMConfig = DomBasedXssAtmConfig;

/**
 * A taint-tracking configuration for reasoning about XSS vulnerabilities.
 *
 * This is largely a copy of the taint tracking configuration for the standard XSSThroughDom query,
 * except additional ATM sinks have been added to the `isSink` predicate.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "DomBasedXssATMConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof DomBasedXss::Source }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof DomBasedXss::Sink or
    any(DomBasedXssAtmConfig cfg).isEffectiveSink(sink)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof DomBasedXss::Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof PrefixStringSanitizerActivated or
    guard instanceof QuoteGuard or
    guard instanceof ContainsHtmlGuard
  }

  override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    DomBasedXss::isOptionallySanitizedEdge(pred, succ)
  }
}

private import semmle.javascript.security.dataflow.Xss::Shared as Shared

private class PrefixStringSanitizerActivated extends TaintTracking::SanitizerGuardNode,
  DomBasedXss::PrefixStringSanitizer {
  PrefixStringSanitizerActivated() { this = this }
}

private class PrefixStringActivated extends DataFlow::FlowLabel, DomBasedXss::PrefixString {
  PrefixStringActivated() { this = this }
}

private class QuoteGuard extends TaintTracking::SanitizerGuardNode, Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends TaintTracking::SanitizerGuardNode, Shared::ContainsHtmlGuard {
  ContainsHtmlGuard() { this = this }
}
