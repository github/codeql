/**
 * Provides a taint-tracking configuration for reasoning about DOM-based
 * cross-site scripting vulnerabilities.
 */

import javascript
private import semmle.javascript.security.TaintedUrlSuffix
import DomBasedXssCustomizations::DomBasedXss
private import Xss::Shared as Shared

/**
 * A sink that is not a URL write or a JQuery selector,
 * assumed to be a value that is interpreted as HTML.
 */
class HtmlSink extends DataFlow::Node instanceof Sink {
  HtmlSink() {
    not this instanceof WriteUrlSink and
    not this instanceof JQueryHtmlOrSelectorSink
  }
}

/** DEPRECATED: Alias for HtmlSink */
deprecated class HTMLSink = HtmlSink;

/**
 * A taint-tracking configuration for reasoning about XSS.
 * Both ordinary HTML sinks, URL sinks, and JQuery selector based sinks.
 * - HTML sinks are sinks for any tainted value
 * - URL sinks are only sinks when the scheme is user controlled
 * - JQuery selector sinks are sinks when the tainted value can start with `<`.
 *
 * The above is achieved using three flow labels:
 * - TaintedUrlSuffix: a URL where the attacker only controls a suffix.
 * - Taint: a tainted value where the attacker controls part of the value.
 * - PrefixLabel: a tainted value where the attacker controls the prefix
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "HtmlInjection" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source instanceof Source and
    (label.isTaint() or label = prefixLabel()) and
    not source = TaintedUrlSuffix::source()
    or
    source = TaintedUrlSuffix::source() and
    label = TaintedUrlSuffix::label()
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof HtmlSink and
    label = [TaintedUrlSuffix::label(), prefixLabel(), DataFlow::FlowLabel::taint()]
    or
    sink instanceof JQueryHtmlOrSelectorSink and
    label = [DataFlow::FlowLabel::taint(), prefixLabel()]
    or
    sink instanceof WriteUrlSink and
    label = prefixLabel()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    node instanceof Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof PrefixStringSanitizerActivated or
    guard instanceof QuoteGuard or
    guard instanceof ContainsHtmlGuard
  }

  override predicate isLabeledBarrier(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    super.isLabeledBarrier(node, lbl)
    or
    // copy all taint barriers to the TaintedUrlSuffix/PrefixLabel label. This copies both the ordinary sanitizers and the sanitizer-guards.
    super.isLabeledBarrier(node, DataFlow::FlowLabel::taint()) and
    lbl = [TaintedUrlSuffix::label(), prefixLabel()]
    or
    // any non-first string-concatenation leaf is a barrier for the prefix label.
    exists(StringOps::ConcatenationRoot root |
      node = root.getALeaf() and
      not node = root.getFirstLeaf() and
      lbl = prefixLabel()
    )
    or
    // we assume that `.join()` calls have a prefix, and thus block the prefix label.
    node = any(DataFlow::MethodCallNode call | call.getMethodName() = "join") and
    lbl = prefixLabel()
    or
    isOptionallySanitizedNode(node) and
    lbl = [DataFlow::FlowLabel::taint(), prefixLabel(), TaintedUrlSuffix::label()]
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedUrlSuffix::step(src, trg, inlbl, outlbl)
    or
    exists(DataFlow::Node operator |
      StringConcatenation::taintStep(src, trg, operator, _) and
      StringConcatenation::getOperand(operator, 0).getStringValue() = "<" + any(string s) and
      inlbl = TaintedUrlSuffix::label() and
      outlbl.isTaint()
    )
    or
    // inherit all ordinary taint steps for prefixLabel
    inlbl = prefixLabel() and
    outlbl = prefixLabel() and
    TaintTracking::sharedTaintStep(src, trg)
    or
    // steps out of taintedSuffixlabel to taint-label are also a steps to prefixLabel.
    TaintedUrlSuffix::step(src, trg, TaintedUrlSuffix::label(), DataFlow::FlowLabel::taint()) and
    inlbl = TaintedUrlSuffix::label() and
    outlbl = prefixLabel()
    or
    exists(DataFlow::FunctionNode callback, DataFlow::Node arg |
      any(JQuery::MethodCall c).interpretsArgumentAsHtml(arg) and
      callback = arg.getABoundFunctionValue(_) and
      src = callback.getReturnNode() and
      trg = callback and
      inlbl = outlbl
    )
  }
}

private class PrefixStringSanitizerActivated extends TaintTracking::SanitizerGuardNode,
  PrefixStringSanitizer
{
  PrefixStringSanitizerActivated() { this = this }
}

private class PrefixStringActivated extends DataFlow::FlowLabel, PrefixString {
  PrefixStringActivated() { this = this }
}

private class QuoteGuard extends TaintTracking::SanitizerGuardNode, Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends TaintTracking::SanitizerGuardNode, Shared::ContainsHtmlGuard
{
  ContainsHtmlGuard() { this = this }
}
