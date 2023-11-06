/**
 * Provides a taint-tracking configuration for detecting "Code injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `CodeInjectionFlow` is needed, otherwise
 * `CodeInjectionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import CodeInjectionCustomizations::CodeInjection
import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for detecting "Code injection" vulnerabilities.
 * DEPRECATED: Use `CodeInjectionFlow` instead
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CodeInjection" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    state = source.(Source).getAFlowState()
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    state = sink.(Sink).getAFlowState()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof Sanitizer and not exists(node.(Sanitizer).getAFlowState())
    or
    node instanceof StringConstCompareBarrier
    or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  override predicate isSanitizer(DataFlow::Node node, DataFlow::FlowState state) {
    node.(Sanitizer).getAFlowState() = state
  }
}

private module Config implements DataFlow::StateConfigSig {
  class FlowState = FlowState::State;

  predicate isSource(DataFlow::Node source, FlowState state) { state = source.(Source).getAState() }

  predicate isSink(DataFlow::Node sink, FlowState state) { state = sink.(Sink).getAState() }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer and not exists(node.(Sanitizer).getAState())
    or
    node instanceof StringConstCompareBarrier
    or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) { node.(Sanitizer).getAState() = state }
}

/**
 * Taint-tracking for detecting "Code injection" vulnerabilities.
 */
module CodeInjectionFlow = TaintTracking::GlobalWithState<Config>;
