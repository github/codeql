/**
 * Provides a taint tracking configuration for reasoning about
 * SQL-injection vulnerabilities (CWE-078).
 *
 * Note, for performance reasons: only import this file if
 * `SqlInjectionFlow` is needed, otherwise
 * `SqlInjectionCustomizations` should be imported instead.
 */

import powershell
import semmle.code.powershell.dataflow.TaintTracking
import SqlInjectionCustomizations::SqlInjection
import semmle.code.powershell.dataflow.DataFlow

private module Config implements DataFlow::StateConfigSig {
  newtype FlowState =
    additional BeforeConcat() or
    additional AfterConcat()

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof Source and state = BeforeConcat()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof Sink and state = AfterConcat()
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    state1 = BeforeConcat() and
    state2 = AfterConcat() and
    (
      TaintTracking::stringInterpolationTaintStep(node1, node2)
      or
      TaintTracking::operationTaintStep(node1, node2)
    )
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet cs) {
    node.(Sink).allowImplicitRead(cs)
  }
}

/**
 * Taint-tracking for reasoning about SQL-injection vulnerabilities.
 */
module SqlInjectionFlow = TaintTracking::GlobalWithState<Config>;
