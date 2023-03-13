/**
 * Provides a taint-tracking configuration for reasoning about
 * cross-site scripting vulnerabilities through the DOM.
 */

import javascript
private import XssThroughDomCustomizations::XssThroughDom
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations
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
    guard instanceof UnsafeJQuery::NumberGuard or
    guard instanceof PrefixStringSanitizer or
    guard instanceof QuoteGuard or
    guard instanceof ContainsHtmlGuard
  }

  override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    DomBasedXss::isOptionallySanitizedEdge(pred, succ)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    succ = DataFlow::globalVarRef("URL").getAMemberCall("createObjectURL") and
    pred = succ.(DataFlow::InvokeNode).getArgument(0)
  }

  override predicate hasFlowPath(DataFlow::SourcePathNode src, DataFlow::SinkPathNode sink) {
    super.hasFlowPath(src, sink) and
    // filtering away readings of `src` that end in a URL sink.
    not (
      sink.getNode() instanceof DomBasedXss::WriteUrlSink and
      src.getNode().(DomPropertySource).getPropertyName() = "src"
    )
  }
}

/** A test for the value of `typeof x`, restricting the potential types of `x`. */
class TypeTestGuard extends TaintTracking::SanitizerGuardNode, DataFlow::ValueNode {
  override EqualityTest astNode;
  Expr operand;
  boolean polarity;

  TypeTestGuard() { TaintTracking::isStringTypeGuard(astNode, operand, polarity) }

  override predicate sanitizes(boolean outcome, Expr e) {
    polarity = outcome and
    e = operand
  }
}

private import semmle.javascript.security.dataflow.Xss::Shared as Shared

private class PrefixStringSanitizer extends TaintTracking::SanitizerGuardNode,
  DomBasedXss::PrefixStringSanitizer
{
  PrefixStringSanitizer() { this = this }
}

private class PrefixString extends DataFlow::FlowLabel, DomBasedXss::PrefixString {
  PrefixString() { this = this }
}

private class QuoteGuard extends TaintTracking::SanitizerGuardNode, Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends TaintTracking::SanitizerGuardNode, Shared::ContainsHtmlGuard
{
  ContainsHtmlGuard() { this = this }
}
