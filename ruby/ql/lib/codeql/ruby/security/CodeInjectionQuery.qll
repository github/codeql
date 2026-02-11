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

  predicate isBarrierIn(DataFlow::Node node) { node instanceof Source }

  int fieldFlowBranchLimit() { result = 10 }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting "Code injection" vulnerabilities.
 */
module CodeInjectionFlow = TaintTracking::GlobalWithState<Config>;
