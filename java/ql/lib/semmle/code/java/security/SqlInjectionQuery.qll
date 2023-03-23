/**
 * Provides taint tracking and dataflow configurations to be used in Sql injection queries.
 *
 * Do not import this from a library file, in order to reduce the risk of
 * unintentionally bringing a TaintTracking::Configuration into scope in an unrelated
 * query.
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.QueryInjection

/**
 * DEPRECATED: Use `QueryInjectionFlow` instead.
 *
 * A taint-tracking configuration for unvalidated user input that is used in SQL queries.
 */
deprecated class QueryInjectionFlowConfig extends TaintTracking::Configuration {
  QueryInjectionFlowConfig() { this = "SqlInjectionLib::QueryInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalQueryInjectionTaintStep s).step(node1, node2)
  }
}

/**
 * A taint-tracking configuration for unvalidated user input that is used in SQL queries.
 */
module QueryInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

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

/** Tracks flow of unvalidated user input that is used in SQL queries. */
module QueryInjectionFlow = TaintTracking::Make<QueryInjectionFlowConfig>;

/**
 * Implementation of `SqlTainted.ql`. This is extracted to a QLL so that it
 * can be excluded from `SqlConcatenated.ql` to avoid overlapping results.
 */
predicate queryTaintedBy(
  QueryInjectionSink query, QueryInjectionFlow::PathNode source, QueryInjectionFlow::PathNode sink
) {
  QueryInjectionFlow::hasFlowPath(source, sink) and sink.getNode() = query
}
