/**
 * @id java/sensitiveinfo-in-logfile
 * @name Insertion of sensitive information into log files
 * @description Writing sensitive information to log files can give valuable guidance to an attacker or expose sensitive user information.
 * @kind path-problem
 * @tags security
 *       external/cwe-532
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow
import PathGraph

/**
 * Gets a regular expression for matching names of variables that indicate the value being held is a credential
 */
private string getACredentialRegex() {
  result = "(?i).*challenge|pass(wd|word|code|phrase)(?!.*question).*" or
  result = "(?i)(.*username|.*secret|url).*"
}

/** Variable keeps sensitive information judging by its name * */
class CredentialExpr extends Expr {
  CredentialExpr() {
    exists(Variable v | this = v.getAnAccess() | v.getName().regexpMatch(getACredentialRegex()))
  }
}

/** Class of popular logging utilities * */
class LoggerType extends RefType {
  LoggerType() {
    this.hasQualifiedName("org.apache.log4j", "Category") or //Log4J
    this.hasQualifiedName("org.apache.logging.log4j", "Logger") or //Log4J 2
    this.hasQualifiedName("org.slf4j", "Logger") or //SLF4j and Gradle Logging
    this.hasQualifiedName("org.jboss.logging", "BasicLogger") or //JBoss Logging
    this.hasQualifiedName("org.jboss.logging", "Logger") or //JBoss Logging (`org.jboss.logging.Logger` in some implementations like JBoss Application Server 4.0.4 did not implement `BasicLogger`)
    this.hasQualifiedName("org.apache.commons.logging", "Log") or //Apache Commons Logging
    this.hasQualifiedName("org.scijava.log", "Logger") //SciJava Logging
  }
}

predicate isSensitiveLoggingSink(DataFlow::Node sink) {
  exists(MethodAccess ma |
    ma.getMethod().getDeclaringType() instanceof LoggerType and
    (
      ma.getMethod().hasName("debug") or
      ma.getMethod().hasName("trace") or
      ma.getMethod().hasName("debugf") or
      ma.getMethod().hasName("debugv")
    ) and //Check low priority log levels which are more likely to be real issues to reduce false positives
    sink.asExpr() = ma.getAnArgument()
  )
}

class LoggerConfiguration extends DataFlow::Configuration {
  LoggerConfiguration() { this = "Logger Configuration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CredentialExpr }

  override predicate isSink(DataFlow::Node sink) { isSensitiveLoggingSink(sink) }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    TaintTracking::localTaintStep(node1, node2)
  }
}

from LoggerConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Outputting $@ to log.", source.getNode(),
  "sensitive information"
