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

/**
 * A taint-tracking configuration for reasoning about XSS by DOM manipulation.
 *
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
module DomBasedXssConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source instanceof Source and
    (label.isTaint() or label = prefixLabel()) and
    not source = TaintedUrlSuffix::source()
    or
    source = TaintedUrlSuffix::source() and
    label = TaintedUrlSuffix::label()
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof HtmlSink and
    label = [TaintedUrlSuffix::label(), prefixLabel(), DataFlow::FlowLabel::taint()]
    or
    sink instanceof JQueryHtmlOrSelectorSink and
    label = [DataFlow::FlowLabel::taint(), prefixLabel()]
    or
    sink instanceof WriteUrlSink and
    label = prefixLabel()
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or node = Shared::BarrierGuard::getABarrierNode()
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    // copy all taint barrier guards to the TaintedUrlSuffix/PrefixLabel label
    TaintTracking::defaultSanitizer(node) and
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
    or
    TaintedUrlSuffix::isBarrier(node, lbl)
    or
    node = DataFlow::MakeLabeledBarrierGuard<BarrierGuard>::getABarrierNode(lbl)
  }

  predicate isBarrierIn(DataFlow::Node node, DataFlow::FlowLabel label) { isSource(node, label) }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowLabel state1, DataFlow::Node node2,
    DataFlow::FlowLabel state2
  ) {
    TaintedUrlSuffix::step(node1, node2, state1, state2)
    or
    exists(DataFlow::Node operator |
      StringConcatenation::taintStep(node1, node2, operator, _) and
      StringConcatenation::getOperand(operator, 0).getStringValue() = "<" + any(string s) and
      state1 = TaintedUrlSuffix::label() and
      state2.isTaint()
    )
    or
    // steps out of taintedSuffixlabel to taint-label are also steps to prefixLabel.
    TaintedUrlSuffix::step(node1, node2, TaintedUrlSuffix::label(), DataFlow::FlowLabel::taint()) and
    state1 = TaintedUrlSuffix::label() and
    state2 = prefixLabel()
    or
    // FIXME: this fails to work in the test case at jquery.js:37
    exists(DataFlow::FunctionNode callback, DataFlow::Node arg |
      any(JQuery::MethodCall c).interpretsArgumentAsHtml(arg) and
      callback = arg.getABoundFunctionValue(_) and
      node1 = callback.getReturnNode() and
      node2 = callback and
      state1 = state2
    )
  }
}

/**
 * Taint-tracking for reasoning about XSS by DOM manipulation.
 */
module DomBasedXssFlow = TaintTracking::GlobalWithState<DomBasedXssConfig>;

/**
 * DEPRECATED. Use the `DomBasedXssFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "HtmlInjection" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    DomBasedXssConfig::isSource(source, label)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    DomBasedXssConfig::isSink(sink, label)
  }

  override predicate isSanitizer(DataFlow::Node node) { DomBasedXssConfig::isBarrier(node) }

  override predicate isLabeledBarrier(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    DomBasedXssConfig::isBarrier(node, lbl)
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::Node node2, DataFlow::FlowLabel state1,
    DataFlow::FlowLabel state2
  ) {
    DomBasedXssConfig::isAdditionalFlowStep(node1, state1, node2, state2)
    or
    // inherit all ordinary taint steps for the prefix label
    state1 = prefixLabel() and
    state2 = prefixLabel() and
    TaintTracking::sharedTaintStep(node1, node2)
  }
}

private class PrefixStringSanitizerActivated extends PrefixStringSanitizer {
  PrefixStringSanitizerActivated() { this = this }
}

private class PrefixStringActivated extends DataFlow::FlowLabel, PrefixString {
  PrefixStringActivated() { this = this }
}

private class QuoteGuard extends Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends Shared::ContainsHtmlGuard {
  ContainsHtmlGuard() { this = this }
}
