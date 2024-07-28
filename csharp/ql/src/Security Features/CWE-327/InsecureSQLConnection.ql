/**
 * @name Insecure SQL connection
 * @description Using an SQL Server connection without enforcing encryption is a security vulnerability.
 * @kind path-problem
 * @id cs/insecure-sql-connection
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @tags security
 *       external/cwe/cwe-327
 */

import csharp
import InsecureSqlConnection::PathGraph

/**
 * A data flow configuration for tracking strings passed to `SqlConnection[StringBuilder]` instances.
 */
module InsecureSqlConnectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(string s | s = source.asExpr().(StringLiteral).getValue().toLowerCase() |
      s.matches("%encrypt=false%")
      or
      not s.matches("%encrypt=%")
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(ObjectCreation oc |
      oc.getRuntimeArgument(0) = sink.asExpr() and
      (
        oc.getType().getName() = "SqlConnectionStringBuilder"
        or
        oc.getType().getName() = "SqlConnection"
      ) and
      not exists(MemberInitializer mi |
        mi = oc.getInitializer().(ObjectInitializer).getAMemberInitializer() and
        mi.getLValue().(PropertyAccess).getTarget().getName() = "Encrypt" and
        mi.getRValue().(BoolLiteral).getValue() = "true"
      )
    )
  }
}

/**
 * A data flow configuration for tracking strings passed to `SqlConnection[StringBuilder]` instances.
 */
module InsecureSqlConnection = DataFlow::Global<InsecureSqlConnectionConfig>;

from InsecureSqlConnection::PathNode source, InsecureSqlConnection::PathNode sink
where InsecureSqlConnection::flowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ flows to this SQL connection and does not specify `Encrypt=True`.", source.getNode(),
  "Connection string"
