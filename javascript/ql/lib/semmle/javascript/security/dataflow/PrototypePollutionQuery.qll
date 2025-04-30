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
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node node, FlowState state) { node.(Source).getAFlowState() = state }

  predicate isSink(DataFlow::Node node, FlowState state) { node.(Sink).getAFlowState() = state }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedObject::isAdditionalFlowStep(node1, state1, node2, state2)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet contents) {
    // For recursive merge sinks, the deeply tainted object only needs to be reachable from the input, the input itself
    // does not need to be deeply tainted.
    isSink(node, FlowState::taintedObject()) and
    contents = DataFlow::ContentSet::anyProperty()
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    node = TaintedObject::SanitizerGuard::getABarrierNode(state)
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    exists(Locatable loc |
      sink.(Sink).dependencyInfo(_, loc) and
      result = loc.getLocation()
    )
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
