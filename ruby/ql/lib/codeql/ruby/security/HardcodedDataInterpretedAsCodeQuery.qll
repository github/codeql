/**
 * Provides a taint-tracking configuration for reasoning about hard-coded data
 * being interpreted as code.
 *
 * Note, for performance reasons: only import this file if
 * `HardcodedDataInterpretedAsCodeFlow` is needed, otherwise
 * `HardcodedDataInterpretedAsCodeCustomizations` should be imported instead.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.dataflow.internal.TaintTrackingPrivate
import HardcodedDataInterpretedAsCodeCustomizations::HardcodedDataInterpretedAsCode

/**
 * A taint-tracking configuration for reasoning about hard-coded data
 * being interpreted as code.
 *
 * DEPRECATED: Use `HardcodedDataInterpretedAsCodeFlow` instead
 */
deprecated class Configuration extends DataFlow::Configuration {
  Configuration() { this = "HardcodedDataInterpretedAsCode" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState label) {
    source.(Source).getLabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState label) {
    sink.(Sink).getLabel() = label
  }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    defaultAdditionalTaintStep(nodeFrom, nodeTo) and
    // This is a taint step, so the flow state becomes `taint`.
    stateFrom = [FlowState::data(), FlowState::taint()] and
    stateTo = FlowState::taint()
  }
}

private module Config implements DataFlow::StateConfigSig {
  class FlowState = FlowState::State;

  predicate isSource(DataFlow::Node source, FlowState label) { source.(Source).getALabel() = label }

  predicate isSink(DataFlow::Node sink, FlowState label) { sink.(Sink).getALabel() = label }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    defaultAdditionalTaintStep(nodeFrom, nodeTo) and
    // This is a taint step, so the flow state becomes `taint`.
    (
      stateFrom = FlowState::Taint()
      or
      stateFrom = FlowState::Data()
    ) and
    stateTo = FlowState::Taint()
  }
}

/**
 * Taint-tracking for reasoning about hard-coded data being interpreted as code.
 * We implement `DataFlow::GlobalWithState` rather than
 * `TaintTracking::GlobalWithState`, so that we can set the flow state to
 * `Taint()` on a taint step.
 */
module HardcodedDataInterpretedAsCodeFlow = DataFlow::GlobalWithState<Config>;
