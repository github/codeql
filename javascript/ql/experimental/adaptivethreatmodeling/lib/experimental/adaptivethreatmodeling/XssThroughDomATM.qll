/**
 * For internal use only.
 *
 * A taint-tracking configuration for reasoning about XSS through the DOM.
 * Defines shared code used by the XSS Through DOM boosted query.
 */

private import semmle.javascript.heuristics.SyntacticHeuristics
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.security.dataflow.XssThroughDomCustomizations::XssThroughDom as XssThroughDom
private import semmle.javascript.security.dataflow.UnsafeJQueryPluginCustomizations::UnsafeJQueryPlugin as UnsafeJQuery
import AdaptiveThreatModeling

class XssThroughDomAtmConfig extends AtmConfig {
  XssThroughDomAtmConfig() { this = "XssThroughDomAtmConfig" }

  override predicate isKnownSource(DataFlow::Node source) {
    source instanceof XssThroughDom::Source
  }

  override EndpointType getASinkEndpointType() { result instanceof XssSinkType }

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
