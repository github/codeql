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
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.(Source).getAFlowState() = state
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof Sink and state.isTaintedObject()
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    node = TaintedObject::SanitizerGuard::getABarrierNode(state)
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedObject::isAdditionalFlowStep(node1, state1, node2, state2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    exists(DataFlow::Node link |
      sink.(Sink).hasReason(link, _) and
      result = link.getLocation()
    )
  }
}

/**
 * Taint tracking for reasoning about DoS attacks due to inefficient handling
 * of user-controlled objects.
 */
module DeepObjectResourceExhaustionFlow =
  TaintTracking::GlobalWithState<DeepObjectResourceExhaustionConfig>;
