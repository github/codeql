/**
 * Provides a taint-tracking configuration for reasoning about local user input
 * that is used in a SQL query.
 */

import semmle.code.java.Expr
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SqlInjectionQuery

/**
 * A taint-tracking configuration for reasoning about local user input that is
 * used in a SQL query.
 */
module LocalUserInputToQueryInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalQueryInjectionTaintStep s).step(node1, node2)
  }
}

/**
 * Taint-tracking flow for local user input that is used in a SQL query.
 */
module LocalUserInputToQueryInjectionFlow =
  TaintTracking::Global<LocalUserInputToQueryInjectionFlowConfig>;
