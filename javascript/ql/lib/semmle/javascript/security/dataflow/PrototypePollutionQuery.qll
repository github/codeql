/**
 * Provides a taint-tracking configuration for tracking
 * user-controlled objects flowing into a vulnerable `extends` call.
 *
 * Note, for performance reasons: only import this file if
 * `PrototypePollution::Configuration` is needed, otherwise
 * `PrototypePollutionCustomizations` should be imported instead.
 */

import javascript
import semmle.javascript.security.TaintedObject
import semmle.javascript.dependencies.SemVer
import PrototypePollutionCustomizations::PrototypePollution

// Materialize flow labels
/**
 * We no longer use this flow label, since it does not work in a world where flow states inherit taint steps.
 */
deprecated private class ConcreteTaintedObjectWrapper extends TaintedObjectWrapper {
  ConcreteTaintedObjectWrapper() { this = this }
}

/**
 * A taint tracking configuration for user-controlled objects flowing into deep `extend` calls,
 * leading to prototype pollution.
 */
module PrototypePollutionConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node node, DataFlow::FlowLabel label) {
    node.(Source).getAFlowLabel() = label
  }

  predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    node.(Sink).getAFlowLabel() = label
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::FlowLabel inlbl, DataFlow::Node dst, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, dst, inlbl, outlbl)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet contents) {
    // For recursive merge sinks, the deeply tainted object only needs to be reachable from the input, the input itself
    // does not need to be deeply tainted.
    isSink(node, TaintedObject::label()) and
    contents = DataFlow::ContentSet::anyProperty()
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowLabel label) {
    node = TaintedObject::SanitizerGuard::getABarrierNode(label)
  }
}

/**
 * Taint tracking for user-controlled objects flowing into deep `extend` calls,
 * leading to prototype pollution.
 */
module PrototypePollutionFlow = TaintTracking::GlobalWithState<PrototypePollutionConfig>;

/**
 * DEPRECATED. Use the `PrototypePollutionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PrototypePollution" }

  override predicate isSource(DataFlow::Node node, DataFlow::FlowLabel label) {
    node.(Source).getAFlowLabel() = label
  }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    node.(Sink).getAFlowLabel() = label
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, dst, inlbl, outlbl)
    or
    // Track objects are wrapped in other objects
    exists(DataFlow::PropWrite write |
      src = write.getRhs() and
      inlbl = TaintedObject::label() and
      dst = write.getBase().getALocalSource() and
      outlbl = TaintedObjectWrapper::label()
    )
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
    node instanceof TaintedObject::SanitizerGuard
  }
}
