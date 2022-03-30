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
import semmle.code.csharp.security.dataflow.SqlInjectionQuery as SqlInjection
import semmle.code.csharp.security.dataflow.flowsources.Stored
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

class StoredTaintTrackingConfiguration extends SqlInjection::TaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) { source instanceof StoredFlowSource }
}

from StoredTaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in an SQL query.",
  source.getNode(), "Stored user-provided value"
