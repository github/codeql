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
 * The above is achieved using three flow states:
 * - TaintedUrlSuffix: a URL where the attacker only controls a suffix.
 * - Taint: a tainted value where the attacker controls part of the value.
 * - PrefixLabel: a tainted value where the attacker controls the prefix
 */
module DomBasedXssConfig implements DataFlow::StateConfigSig {
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof Source and
    (state.isTaint() or state.isTaintedPrefix()) and
    not source = TaintedUrlSuffix::source()
    or
    source = TaintedUrlSuffix::source() and
    state.isTaintedUrlSuffix()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof HtmlSink and
    (state.isTaint() or state.isTaintedPrefix() or state.isTaintedUrlSuffix())
    or
    sink instanceof JQueryHtmlOrSelectorSink and
    (state.isTaint() or state.isTaintedPrefix())
    or
    sink instanceof WriteUrlSink and
    state.isTaintedPrefix()
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer
    or
    node = Shared::BarrierGuard::getABarrierNode()
    or
    isOptionallySanitizedNode(node)
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    // copy all taint barrier guards to the TaintedUrlSuffix/PrefixLabel state
    TaintTracking::defaultSanitizer(node) and
    (state.isTaintedUrlSuffix() or state.isTaintedPrefix())
    or
    // any non-first string-concatenation leaf is a barrier for the prefix state.
    exists(StringOps::ConcatenationRoot root |
      node = root.getALeaf() and
      not node = root.getFirstLeaf() and
      state.isTaintedPrefix()
    )
    or
    // we assume that `.join()` calls have a prefix, and thus block the prefix state.
    node = any(DataFlow::MethodCallNode call | call.getMethodName() = "join") and
    state.isTaintedPrefix()
    or
    TaintedUrlSuffix::isStateBarrier(node, TaintedUrlSuffix::FlowState::taintedUrlSuffix()) and
    state.isTaintedUrlSuffix()
    or
    node = DataFlow::MakeStateBarrierGuard<FlowState, BarrierGuard>::getABarrierNode(state)
  }

  predicate isBarrierIn(DataFlow::Node node, FlowState state) { isSource(node, state) }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedUrlSuffix::isAdditionalFlowStep(node1, state1, node2, state2)
    or
    exists(DataFlow::Node operator |
      StringConcatenation::taintStep(node1, node2, operator, _) and
      StringConcatenation::getOperand(operator, 0).getStringValue() = "<" + any(string s) and
      state1.isTaintedUrlSuffix() and
      state2.isTaint()
    )
    or
    // steps out of tainted-url-suffix to taint are also steps to tainted-prefix.
    TaintedUrlSuffix::isAdditionalFlowStep(node1, FlowState::taintedUrlSuffix(), node2,
      FlowState::taint()) and
    state1.isTaintedUrlSuffix() and
    state2.isTaintedPrefix()
    or
    exists(DataFlow::FunctionNode callback, DataFlow::Node arg |
      any(JQuery::MethodCall c).interpretsArgumentAsHtml(arg) and
      callback = arg.getABoundFunctionValue(_) and
      node1 = callback.getReturnNode() and
      node2 = callback and
      state1 = state2
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
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
    DomBasedXssConfig::isSource(source, FlowState::fromFlowLabel(label))
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    DomBasedXssConfig::isSink(sink, FlowState::fromFlowLabel(label))
  }

  override predicate isSanitizer(DataFlow::Node node) { DomBasedXssConfig::isBarrier(node) }

  override predicate isLabeledBarrier(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    DomBasedXssConfig::isBarrier(node, FlowState::fromFlowLabel(lbl))
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::Node node2, DataFlow::FlowLabel state1,
    DataFlow::FlowLabel state2
  ) {
    DomBasedXssConfig::isAdditionalFlowStep(node1, FlowState::fromFlowLabel(state1), node2,
      FlowState::fromFlowLabel(state2))
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

deprecated private class PrefixStringActivated extends DataFlow::FlowLabel, PrefixString {
  PrefixStringActivated() { this = this }
}

private class QuoteGuard extends Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends Shared::ContainsHtmlGuard {
  ContainsHtmlGuard() { this = this }
}
