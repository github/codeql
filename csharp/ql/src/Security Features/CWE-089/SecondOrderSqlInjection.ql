/**
 * @name SQL query built from stored user-controlled sources
 * @description Building a SQL query from stored user-controlled sources is vulnerable to insertion
 *              of malicious SQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision medium
 * @id cs/second-order-sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import csharp
import semmle.code.csharp.security.dataflow.SqlInjectionQuery
import semmle.code.csharp.security.dataflow.flowsources.Stored
import StoredSqlInjection::PathGraph

module StoredSqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof StoredFlowSource }

  predicate isSink = SqlInjectionConfig::isSink/1;

  predicate isBarrier = SqlInjectionConfig::isBarrier/1;
}

module StoredSqlInjection = TaintTracking::Global<StoredSqlInjectionConfig>;

from StoredSqlInjection::PathNode source, StoredSqlInjection::PathNode sink
where StoredSqlInjection::flowPath(source, sink)
select sink.getNode(), source, sink, "This SQL query depends on a $@.", source.getNode(),
  "stored user-provided value"
