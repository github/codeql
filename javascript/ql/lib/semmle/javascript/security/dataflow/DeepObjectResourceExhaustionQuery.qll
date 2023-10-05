/**
 * Provides a taint tracking configuration for reasoning about DoS attacks
 * due to inefficient handling of user-controlled objects.
 */

import javascript
import semmle.javascript.security.TaintedObject
import DeepObjectResourceExhaustionCustomizations::DeepObjectResourceExhaustion

/**
 * A taint tracking configuration for reasoning about DoS attacks due to inefficient handling
 * of user-controlled objects.
 */
module DeepObjectResourceExhaustionConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getAFlowLabel() = label
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof Sink and label = TaintedObject::label()
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowLabel label) {
    node = TaintedObject::SanitizerGuard::getABarrierNode(label)
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::FlowLabel inlbl, DataFlow::Node trg, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
  }
}

/**
 * Taint tracking for reasoning about DoS attacks due to inefficient handling
 * of user-controlled objects.
 */
module DeepObjectResourceExhaustionFlow =
  TaintTracking::GlobalWithState<DeepObjectResourceExhaustionConfig>;

/**
 * DEPRECATED. Use the `DeepObjectResourceExhaustionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "DeepObjectResourceExhaustion" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getAFlowLabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof Sink and label = TaintedObject::label()
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
  }
}
