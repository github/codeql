/**
 * Provides a taint-tracking configuration for reasoning about local user input
 * that is used in a SQL query.
 */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.SqlInjectionQuery
private import semmle.code.java.security.Sanitizers

/**
 * A taint-tracking configuration for reasoning about local user input that is
 * used in a SQL query.
 */
deprecated module LocalUserInputToQueryInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof SimpleTypeSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalQueryInjectionTaintStep s).step(node1, node2)
  }
}

/**
 * DEPRECATED: Use `QueryInjectionFlow` instead and configure threat model sources to include `local`.
 *
 * Taint-tracking flow for local user input that is used in a SQL query.
 */
deprecated module LocalUserInputToQueryInjectionFlow =
  TaintTracking::Global<LocalUserInputToQueryInjectionFlowConfig>;
