/** Provides configurations for sensitive logging queries. */

import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import DataFlow

/** A variable that may hold sensitive information, judging by its name. * */
class CredentialExpr extends Expr {
  CredentialExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().regexpMatch([getCommonSensitiveInfoRegex(), "(?i).*(username).*"]) and
      not v.isFinal()
    )
  }
}

/** A data-flow configuration for identifying potentially-sensitive data flowing to a log output. */
class SensitiveLoggerConfiguration extends TaintTracking::Configuration {
  SensitiveLoggerConfiguration() { this = "SensitiveLoggerConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CredentialExpr }

  override predicate isSink(DataFlow::Node sink) { sinkNode(sink, "logging") }
}
