/**
 * Provides a taint-tracking configuration for reasoning about local user input
 * that is used in a SQL query.
 */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.SqlInjectionQuery

/**
 * A taint-tracking configuration for reasoning about local user input that is
 * used in a SQL query.
 */
module LocalUserInputToQueryInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
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
