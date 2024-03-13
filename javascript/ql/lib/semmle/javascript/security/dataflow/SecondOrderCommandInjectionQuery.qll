/**
 * Provides a taint tracking configuration for reasoning about
 * second order command-injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `SecondOrderCommandInjection::Configuration` is needed, otherwise
 * `SecondOrderCommandInjectionCustomizations` should be imported instead.
 */

import javascript
import SecondOrderCommandInjectionCustomizations::SecondOrderCommandInjection
private import semmle.javascript.security.TaintedObject

/**
 * A taint-tracking configuration for reasoning about second order command-injection vulnerabilities.
 */
module SecondOrderCommandInjectionConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getALabel() = label
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getALabel() = label
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowLabel label) {
    TaintTracking::defaultSanitizer(node) and
    label.isTaint()
    or
    node = DataFlow::MakeLabeledBarrierGuard<BarrierGuard>::getABarrierNode(label)
    or
    node = TaintedObject::SanitizerGuard::getABarrierNode(label)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::FlowLabel inlbl, DataFlow::Node trg, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
    or
    // We're not using a taint-tracking config because taint steps would then apply to all flow states.
    // So we use a plain data flow config and manually add the default taint steps.
    inlbl.isTaint() and
    TaintTracking::defaultTaintStep(src, trg) and
    inlbl = outlbl
  }
}

/**
 * Taint-tracking for reasoning about second order command-injection vulnerabilities.
 */
module SecondOrderCommandInjectionFlow =
  DataFlow::GlobalWithState<SecondOrderCommandInjectionConfig>;

/**
 * DEPRECATED. Use the `SecondOrderCommandInjectionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SecondOrderCommandInjection" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getALabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getALabel() = label
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof PrefixStringSanitizer or
    guard instanceof DoubleDashSanitizer or
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
  }
}
