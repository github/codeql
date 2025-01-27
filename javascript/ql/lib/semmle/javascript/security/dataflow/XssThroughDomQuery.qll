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
module XssThroughDomConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof DomBasedXss::Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof DomBasedXss::Sanitizer or
    DomBasedXss::isOptionallySanitizedNode(node) or
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode() or
    node = DataFlow::MakeBarrierGuard<UnsafeJQuery::BarrierGuard>::getABarrierNode() or
    node = Shared::BarrierGuard::getABarrierNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node2 = DataFlow::globalVarRef("URL").getAMemberCall("createObjectURL") and
    node1 = node2.(DataFlow::InvokeNode).getArgument(0)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking configuration for reasoning about XSS through the DOM.
 */
module XssThroughDomFlow = TaintTracking::Global<XssThroughDomConfig>;

/**
 * Holds if the `source,sink` pair should not be reported.
 */
bindingset[source, sink]
predicate isIgnoredSourceSinkPair(Source source, DomBasedXss::Sink sink) {
  source.(DomPropertySource).getPropertyName() = "src" and
  sink instanceof DomBasedXss::WriteUrlSink
}

/**
 * DEPRECATED. Use the `XssThroughDomFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "XssThroughDOM" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof DomBasedXss::Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof DomBasedXss::Sanitizer or
    DomBasedXss::isOptionallySanitizedNode(node)
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TypeTestGuard or
    guard instanceof UnsafeJQuery::PropertyPresenceSanitizer or
    guard instanceof UnsafeJQuery::NumberGuard or
    guard instanceof PrefixStringSanitizer or
    guard instanceof QuoteGuard or
    guard instanceof ContainsHtmlGuard
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
class TypeTestGuard extends BarrierGuard, DataFlow::ValueNode {
  override EqualityTest astNode;
  Expr operand;
  boolean polarity;

  TypeTestGuard() { TaintTracking::isStringTypeGuard(astNode, operand, polarity) }

  override predicate blocksExpr(boolean outcome, Expr e) {
    polarity = outcome and
    e = operand
  }
}

private import semmle.javascript.security.dataflow.Xss::Shared as Shared

private class PrefixStringSanitizer extends DomBasedXss::PrefixStringSanitizer {
  PrefixStringSanitizer() { this = this }
}

deprecated private class PrefixString extends DataFlow::FlowLabel, DomBasedXss::PrefixString {
  PrefixString() { this = this }
}

private class QuoteGuard extends Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends Shared::ContainsHtmlGuard {
  ContainsHtmlGuard() { this = this }
}
