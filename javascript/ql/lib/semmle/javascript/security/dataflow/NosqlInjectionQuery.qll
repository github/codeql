/**
 * Provides a taint tracking configuration for reasoning about NoSQL
 * injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `NosqlInjection::Configuration` is needed, otherwise
 * `NosqlInjectionCustomizations` should be imported instead.
 */

import javascript
import semmle.javascript.security.TaintedObject
import NosqlInjectionCustomizations::NosqlInjection

/**
 * A taint-tracking configuration for reasoning about SQL-injection vulnerabilities.
 */
module NosqlInjectionConfig implements DataFlow::StateConfigSig {
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof Source and state.isTaint()
    or
    source instanceof TaintedObject::Source and state.isTaintedObject()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) { sink.(Sink).getAFlowState() = state }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    node instanceof Sanitizer and state.isTaint()
    or
    TaintTracking::defaultSanitizer(node) and state.isTaint()
    or
    node = TaintedObject::SanitizerGuard::getABarrierNode(state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedObject::isAdditionalFlowStep(node1, state1, node2, state2)
    or
    // additional flow step to track taint through NoSQL query objects
    state1.isTaintedObject() and
    state2.isTaintedObject() and
    exists(NoSql::Query query, DataFlow::SourceNode queryObj |
      queryObj.flowsTo(query) and
      queryObj.flowsTo(node2) and
      node1 = queryObj.getAPropertyWrite().getRhs()
    )
    or
    TaintTracking::defaultTaintStep(node1, node2) and
    state1.isTaint() and
    state2 = state1
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about SQL-injection vulnerabilities.
 */
module NosqlInjectionFlow = DataFlow::GlobalWithState<NosqlInjectionConfig>;
