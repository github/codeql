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

/*
 * We implement `DataFlow::ConfigSig` rather than
 * `TaintTracking::ConfigSig`, so that we can set the flow state to
 * `"taint"` on a taint step.
 */

private module Config implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, FlowState label) { source.(Source).getLabel() = label }

  predicate isSink(DataFlow::Node sink, FlowState label) { sink.(Sink).getLabel() = label }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    defaultAdditionalTaintStep(nodeFrom, nodeTo) and
    // This is a taint step, so the flow state becomes `taint`.
    stateFrom = [FlowState::data(), FlowState::taint()] and
    stateTo = FlowState::taint()
  }
}

/**
 * Taint-tracking for reasoning about hard-coded data being interpreted as code.
 */
module HardcodedDataInterpretedAsCodeFlow = DataFlow::GlobalWithState<Config>;
