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

/**
 * DEPRECATED. Use the `NosqlInjectionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "NosqlInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    TaintedObject::isSource(source, label)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getAFlowLabel() = label
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::Node node2, DataFlow::FlowLabel state1,
    DataFlow::FlowLabel state2
  ) {
    NosqlInjectionConfig::isAdditionalFlowStep(node1, FlowState::fromFlowLabel(state1), node2,
      FlowState::fromFlowLabel(state2))
  }
}
