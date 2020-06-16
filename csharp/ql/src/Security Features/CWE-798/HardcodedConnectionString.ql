/**
 * @name Hard-coded connection string with credentials
 * @description Credentials are hard-coded in a connection string in the source code of the application.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/hardcoded-connection-string-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import csharp
import semmle.code.csharp.frameworks.system.Data
import semmle.code.csharp.security.dataflow.HardcodedCredentials
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

/**
 * A string literal containing a username or password field.
 */
class ConnectionStringPasswordOrUsername extends HardcodedCredentials::NonEmptyStringLiteral {
  ConnectionStringPasswordOrUsername() {
    this.getExpr().getValue().regexpMatch("(?i).*(Password|PWD|User Id|UID)=.+")
  }
}

/**
 * A taint-tracking configuration for tracking string literals to a `ConnectionString` property.
 */
class ConnectionStringTaintTrackingConfiguration extends TaintTracking::Configuration {
  ConnectionStringTaintTrackingConfiguration() { this = "connectionstring" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof ConnectionStringPasswordOrUsername
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() =
      any(SystemDataConnectionClass connection).getConnectionStringProperty().getAnAssignedValue()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof HardcodedCredentials::StringFormatSanitizer
  }
}

from
  ConnectionStringTaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "'ConnectionString' property includes hard-coded credentials set in $@.",
  any(Call call | call.getAnArgument() = sink.getNode().asExpr()) as call, call.toString()
