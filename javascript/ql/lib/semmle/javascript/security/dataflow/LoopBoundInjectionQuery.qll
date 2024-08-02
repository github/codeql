/**
 * Provides a taint tracking configuration for reasoning about DoS attacks
 * using a user-controlled object with an unbounded .length property.
 *
 * Note, for performance reasons: only import this file if
 * `LoopBoundInjection::Configuration` is needed, otherwise
 * `LoopBoundInjectionCustomizations` should be imported instead.
 */

import javascript
import LoopBoundInjectionCustomizations::LoopBoundInjection

/**
 * A taint tracking configuration for reasoning about looping on tainted objects with unbounded length.
 */
module LoopBoundInjectionConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source instanceof Source and label = TaintedObject::label()
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof Sink and label = TaintedObject::label()
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowLabel label) {
    node = DataFlow::MakeLabeledBarrierGuard<BarrierGuard>::getABarrierNode(label) or
    node = TaintedObject::SanitizerGuard::getABarrierNode(label)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::FlowLabel inlbl, DataFlow::Node trg, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
  }
}

/**
 * Taint tracking configuration for reasoning about looping on tainted objects with unbounded length.
 */
module LoopBoundInjectionFlow = TaintTracking::GlobalWithState<LoopBoundInjectionConfig>;

/**
 * DEPRECATED. Use the `LoopBoundInjectionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "LoopBoundInjection" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source instanceof Source and label = TaintedObject::label()
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof Sink and label = TaintedObject::label()
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedObject::SanitizerGuard or
    guard instanceof IsArraySanitizerGuard or
    guard instanceof InstanceofArraySanitizerGuard or
    guard instanceof LengthCheckSanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
  }
}
