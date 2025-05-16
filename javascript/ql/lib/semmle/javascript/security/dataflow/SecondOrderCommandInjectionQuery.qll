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
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.(Source).getAFlowState() = state
  }

  predicate isSink(DataFlow::Node sink, FlowState state) { sink.(Sink).getAFlowState() = state }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    TaintTracking::defaultSanitizer(node) and
    state.isTaint()
    or
    node = DataFlow::MakeStateBarrierGuard<FlowState, BarrierGuard>::getABarrierNode(state)
    or
    node = TaintedObject::SanitizerGuard::getABarrierNode(state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedObject::isAdditionalFlowStep(node1, state1, node2, state2)
    or
    // We're not using a taint-tracking config because taint steps would then apply to all flow states.
    // So we use a plain data flow config and manually add the default taint steps.
    state1.isTaint() and
    TaintTracking::defaultTaintStep(node1, node2) and
    state1 = state2
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about second order command-injection vulnerabilities.
 */
module SecondOrderCommandInjectionFlow =
  DataFlow::GlobalWithState<SecondOrderCommandInjectionConfig>;
