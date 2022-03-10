/** Provides configurations for sensitive logging queries. */

import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import DataFlow

/** Variable keeps sensitive information judging by its name * */
class CredentialExpr extends Expr {
  CredentialExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().regexpMatch([getCommonSensitiveInfoRegex(), "(?i).*(username).*"])
    )
  }
}

class SensitiveLoggerConfiguration extends DataFlow::Configuration {
  SensitiveLoggerConfiguration() { this = "SensitiveLoggerConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CredentialExpr }

  override predicate isSink(DataFlow::Node sink) { sinkNode(sink, "logging") }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    TaintTracking::localTaintStep(node1, node2)
  }
}
