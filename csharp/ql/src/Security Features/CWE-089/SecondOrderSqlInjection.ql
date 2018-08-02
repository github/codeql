/**
 * @name SQL query built from stored user-controlled sources
 * @description Building a SQL query from stored user-controlled sources is vulnerable to insertion
 *              of malicious SQL code by the user.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/second-order-sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import csharp
import semmle.code.csharp.security.dataflow.SqlInjection
import semmle.code.csharp.security.dataflow.flowsources.Stored

class StoredTaintTrackingConfiguration extends SqlInjection::TaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) {
    source instanceof StoredFlowSource
  }
}

from StoredTaintTrackingConfiguration c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is used in an SQL query.", source, "Stored user-provided value"
