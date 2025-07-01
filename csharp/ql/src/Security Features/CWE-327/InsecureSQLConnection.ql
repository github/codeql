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
import InsecureSQLConnection

class Source extends DataFlow::Node {
  string sourcestring;

  Source() {
    sourcestring = this.asExpr().(StringLiteral).getValue().toLowerCase() and
    (
      not sourcestring.matches("%encrypt=%") or
      sourcestring.matches("%encrypt=false%")
    )
  }

  predicate setsEncryptFalse() { sourcestring.matches("%encrypt=false%") }
}

class Sink extends DataFlow::Node {
  Version version;

  Sink() {
    exists(ObjectCreation oc |
      oc.getRuntimeArgument(0) = this.asExpr() and
      (
        oc.getType().getName() = "SqlConnectionStringBuilder"
        or
        oc.getType().getName() = "SqlConnection"
      ) and
      version = oc.getType().getALocation().(Assembly).getVersion()
    )
  }

  predicate isEncryptedByDefault() { version.compareTo("4.0") >= 0 }
}

predicate isEncryptTrue(Source source, Sink sink) {
  sink.isEncryptedByDefault() and
  not source.setsEncryptFalse()
  or
  exists(ObjectCreation oc, Expr e | oc.getRuntimeArgument(0) = sink.asExpr() |
    getInfoForInitializedConnEncryption(oc, e) and
    e.getValue().toLowerCase() = "true"
  )
}

/**
 * A data flow configuration for tracking strings passed to `SqlConnection[StringBuilder]` instances.
 */
module InsecureSqlConnectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * A data flow configuration for tracking strings passed to `SqlConnection[StringBuilder]` instances.
 */
module InsecureSqlConnection = DataFlow::Global<InsecureSqlConnectionConfig>;

from InsecureSqlConnection::PathNode source, InsecureSqlConnection::PathNode sink
where
  InsecureSqlConnection::flowPath(source, sink) and
  not isEncryptTrue(source.getNode().(Source), sink.getNode().(Sink))
select sink.getNode(), source, sink,
  "$@ flows to this SQL connection and does not specify `Encrypt=True`.", source.getNode(),
  "Connection string"
