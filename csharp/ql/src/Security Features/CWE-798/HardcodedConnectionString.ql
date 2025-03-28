/**
 * @name Hard-coded connection string with credentials
 * @description Credentials are hard-coded in a connection string in the source code of the application.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id cs/hardcoded-connection-string-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import csharp
import semmle.code.csharp.frameworks.system.Data
import semmle.code.csharp.security.dataflow.HardcodedCredentialsQuery
import ConnectionString::PathGraph

/**
 * A string literal containing a username or password field.
 */
class ConnectionStringPasswordOrUsername extends NonEmptyStringLiteral {
  ConnectionStringPasswordOrUsername() {
    this.getExpr().getValue().regexpMatch("(?i).*(Password|PWD|User Id|UID)=.+")
  }
}

/**
 * A taint-tracking configuration for tracking string literals to a `ConnectionString` property.
 */
module ConnectionStringConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ConnectionStringPasswordOrUsername }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() =
      any(SystemDataConnectionClass connection).getConnectionStringProperty().getAnAssignedValue()
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof StringFormatSanitizer }

  predicate observeDiffInformedIncrementalMode() {
    // TODO(diff-informed): Manually verify if config can be diff-informed.
    // ql/src/Security Features/CWE-798/HardcodedConnectionString.ql:52: Column 5 does not select a source or sink originating from the flow call on line 49
    none()
  }
}

/**
 * A taint-tracking module for tracking string literals to a `ConnectionString` property.
 */
module ConnectionString = TaintTracking::Global<ConnectionStringConfig>;

from ConnectionString::PathNode source, ConnectionString::PathNode sink
where ConnectionString::flowPath(source, sink)
select source.getNode(), source, sink,
  "'ConnectionString' property includes hard-coded credentials set in $@.",
  any(Call call | call.getAnArgument() = sink.getNode().asExpr()) as call, call.toString()
