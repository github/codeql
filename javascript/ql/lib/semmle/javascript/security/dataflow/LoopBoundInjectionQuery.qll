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
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof Source and state.isTaintedObject()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof Sink and state.isTaintedObject()
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    node = DataFlow::MakeStateBarrierGuard<FlowState, BarrierGuard>::getABarrierNode(state) or
    node = TaintedObject::SanitizerGuard::getABarrierNode(state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedObject::isAdditionalFlowStep(node1, state1, node2, state2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint tracking configuration for reasoning about looping on tainted objects with unbounded length.
 */
module LoopBoundInjectionFlow = TaintTracking::GlobalWithState<LoopBoundInjectionConfig>;
