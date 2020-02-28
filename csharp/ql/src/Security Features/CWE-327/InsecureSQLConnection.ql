/**
 * @name Insecure SQL connection
 * @description Using an SQL Server connection without enforcing encryption is a security vulnerability.
 * @kind path-problem
 * @id cs/insecure-sql-connection
 * @problem.severity error
 * @precision medium
 * @tags security
 *       external/cwe/cwe-327
 */

import csharp
import DataFlow::PathGraph

/**
 * A `DataFlow::Configuration` for tracking `Strings passed to SqlConnectionStringBuilder` instances.
 */
class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "TaintTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(string s | s = source.asExpr().(StringLiteral).getValue().toLowerCase() |
      s.matches("%encrypt=false%")
      or
      not s.matches("%encrypt=%")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ObjectCreation oc |
      oc.getRuntimeArgument(0) = sink.asExpr() and
      (
        oc.getType().getName() = "SqlConnectionStringBuilder"
        or
        oc.getType().getName() = "SqlConnection"
      )
    )
  }
}

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and does not specify `Encrypt=True`.",
  source.getNode(), "Connection string"
