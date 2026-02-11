/**
 * Provides taint tracking and dataflow configurations to be used in Sql injection queries.
 *
 * Do not import this from a library file, in order to reduce the risk of
 * unintentionally bringing a TaintTracking::Configuration into scope in an unrelated
 * query.
 */

import java
import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.Sanitizers
import semmle.code.java.security.QueryInjection

/**
 * A taint-tracking configuration for unvalidated user input that is used in SQL queries.
 */
module QueryInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof SimpleTypeSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalQueryInjectionTaintStep s).step(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow of unvalidated user input that is used in SQL queries. */
module QueryInjectionFlow = TaintTracking::Global<QueryInjectionFlowConfig>;

/**
 * Implementation of `SqlTainted.ql`. This is extracted to a QLL so that it
 * can be excluded from `SqlConcatenated.ql` to avoid overlapping results.
 */
predicate queryIsTaintedBy(
  QueryInjectionSink query, QueryInjectionFlow::PathNode source, QueryInjectionFlow::PathNode sink
) {
  QueryInjectionFlow::flowPath(source, sink) and sink.getNode() = query
}
