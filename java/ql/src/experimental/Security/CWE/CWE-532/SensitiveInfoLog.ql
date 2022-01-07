/**
 * @name Insertion of sensitive information into log files
 * @description Writing sensitive information to log files can give valuable
 *              guidance to an attacker or expose sensitive user information.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/sensitiveinfo-in-logfile
 * @tags security
 *       external/cwe/cwe-532
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import experimental.semmle.code.java.Logging
import DataFlow
import PathGraph

/**
 * Gets a regular expression for matching names of variables that indicate the value being held may contain sensitive information
 */
private string getACredentialRegex() { result = "(?i)(.*username|url).*" }

/** Variable keeps sensitive information judging by its name * */
class CredentialExpr extends Expr {
  CredentialExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().regexpMatch([getCommonSensitiveInfoRegex(), getACredentialRegex()])
    )
  }
}

class LoggerConfiguration extends DataFlow::Configuration {
  LoggerConfiguration() { this = "Logger Configuration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CredentialExpr }

  override predicate isSink(DataFlow::Node sink) {
    exists(LoggingCall c | sink.asExpr() = c.getALogArgument())
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    TaintTracking::localTaintStep(node1, node2)
  }
}

from LoggerConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Outputting $@ to log.", source.getNode(),
  "sensitive information"
