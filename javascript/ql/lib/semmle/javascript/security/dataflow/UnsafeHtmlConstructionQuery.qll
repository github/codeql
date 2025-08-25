/**
 * Provides a taint-tracking configuration for reasoning about
 * unsafe HTML constructed from library input vulnerabilities.
 */

import javascript
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations::DomBasedXss as DomBasedXss
private import semmle.javascript.security.dataflow.UnsafeJQueryPluginCustomizations::UnsafeJQueryPlugin as UnsafeJQueryPlugin
import UnsafeHtmlConstructionCustomizations::UnsafeHtmlConstruction
import semmle.javascript.security.TaintedObject

/** DEPRECATED: Mis-spelled class name, alias for Configuration. */
deprecated class Configration = Configuration;

/**
 * A taint-tracking configuration for reasoning about unsafe HTML constructed from library input vulnerabilities.
 */
module UnsafeHtmlConstructionConfig implements DataFlow::StateConfigSig {
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof Source and
    state = [FlowState::taintedObject(), FlowState::taint()]
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof Sink and
    state = FlowState::taint()
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof DomBasedXss::Sanitizer
    or
    node instanceof UnsafeJQueryPlugin::Sanitizer
    or
    DomBasedXss::isOptionallySanitizedNode(node)
    or
    node = Shared::BarrierGuard::getABarrierNode()
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    TaintTracking::defaultSanitizer(node) and state.isTaint()
    or
    node = DataFlow::MakeStateBarrierGuard<FlowState, BarrierGuard>::getABarrierNode(state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedObject::isAdditionalFlowStep(node1, state1, node2, state2)
    or
    // property read from a tainted object is considered tainted
    node2.(DataFlow::PropRead).getBase() = node1 and
    state1.isTaintedObject() and
    state2.isTaint()
    or
    TaintTracking::defaultTaintStep(node1, node2) and
    state1.isTaint() and
    state2 = state1
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getSink().getLocation()
  }
}

/**
 * Taint-tracking for reasoning about unsafe HTML constructed from library input vulnerabilities.
 */
module UnsafeHtmlConstructionFlow = DataFlow::GlobalWithState<UnsafeHtmlConstructionConfig>;

/**
 * DEPRECATED. Use the `UnsafeHtmlConstructionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeHtmlConstruction" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source instanceof Source and
    label = [TaintedObject::label(), DataFlow::FlowLabel::taint(), DataFlow::FlowLabel::data()]
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof Sink and
    label = DataFlow::FlowLabel::taint()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    node instanceof DomBasedXss::Sanitizer
    or
    node instanceof UnsafeJQueryPlugin::Sanitizer
    or
    DomBasedXss::isOptionallySanitizedNode(node)
  }

  // override to require that there is a path without unmatched return steps
  override predicate hasFlowPath(DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink) {
    super.hasFlowPath(source, sink) and
    DataFlow::hasPathWithoutUnmatchedReturn(source, sink)
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    DataFlow::localFieldStep(pred, succ) and
    inlbl.isTaint() and
    outlbl.isTaint()
    or
    TaintedObject::step(pred, succ, inlbl, outlbl)
    or
    // property read from a tainted object is considered tainted
    succ.(DataFlow::PropRead).getBase() = pred and
    inlbl = TaintedObject::label() and
    outlbl = DataFlow::FlowLabel::taint()
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof QuoteGuard or
    guard instanceof ContainsHtmlGuard or
    guard instanceof TypeTestGuard
  }
}

private import semmle.javascript.security.dataflow.Xss::Shared as Shared

private class QuoteGuard extends Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends Shared::ContainsHtmlGuard {
  ContainsHtmlGuard() { this = this }
}
