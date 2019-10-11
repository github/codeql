/**
 * @name Insecure SQL Connection
 * @description Finds uses of insecure SQL Connections string.
 * @kind problem
 * @id cs/insecure-sql-connection
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */
import csharp

/**
 * A `DataFlow::Configuration` for tracking `Strings passed to SqlConnectionStringBuilder` instances.
 */
class UnencryptedSQLConnection_DataflowConfiguration extends TaintTracking::Configuration {
  UnencryptedSQLConnection_DataflowConfiguration() { this = "UnencryptedSQLConnection_DataflowConfiguration" }

  override
  predicate isSource(DataFlow::Node source) {
    exists(string s |
      s = source.asExpr().(StringLiteral).getValue().toLowerCase() |
      s.matches("%encrypt=false%")
      or
      not s.matches("%encrypt=%")
    )
  }

  override
  predicate isSink(DataFlow::Node sink) {
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

from UnencryptedSQLConnection_DataflowConfiguration c, DataFlow::Node source, DataFlow::Node sink, ObjectCreation oc
where
  source != sink
  and c.hasFlow(source, sink)
  and oc.getRuntimeArgument(0) = sink.asExpr()
select oc, "$@ flows to here and does not specific Encrypt=True", source, "Connection string"
