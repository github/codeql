/**
 * @name Insecure SQL connection in Initializer
 * @description Using an SQL Server connection without enforcing encryption is a security vulnerability.
 *              This rule variant will flag when the `encrypt` property is explicitly set to `false` during the object initializer
 * @kind path-problem
 * @id cs/insecure-sql-connection-initializer
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @tags security
 *       external/cwe/cwe-327
 */

import csharp
import InsecureSqlConnectionInitialize::PathGraph
import InsecureSQLConnection

class Source extends DataFlow::Node {
  Source() { this.asExpr().(BoolLiteral).getBoolValue() = false }
}

class Sink extends DataFlow::Node {
  Sink() { getInfoForInitializedConnEncryption(_, this.asExpr()) }
}

/**
 * A data flow configuration for tracking strings passed to `SqlConnection[StringBuilder]` instances.
 */
module InsecureSqlConnectionInitializeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
}

/**
 * A data flow configuration for tracking strings passed to `SqlConnection[StringBuilder]` instances.
 */
module InsecureSqlConnectionInitialize = DataFlow::Global<InsecureSqlConnectionInitializeConfig>;

from
  ObjectCreation oc, InsecureSqlConnectionInitialize::PathNode source,
  InsecureSqlConnectionInitialize::PathNode sink
where
  InsecureSqlConnectionInitialize::flowPath(source, sink) and
  getInfoForInitializedConnEncryption(oc, sink.getNode().asExpr())
select sink.getNode(), source, sink,
  "A value evaluating to $@ flows to $@ and sets the `encrypt` property.", source.getNode(),
  "`false`", oc, "this SQL connection initializer"
