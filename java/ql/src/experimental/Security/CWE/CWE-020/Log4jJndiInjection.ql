/**
 * @name Potential Log4J LDAP JNDI injection (CVE-2021-44228)
 * @description Building Log4j log entries from user-controlled data may allow
 *              attackers to inject malicious code through JNDI lookups when
 *              using Log4J versions vulnerable to CVE-2021-44228.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/log4j-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-020
 *       external/cwe/cwe-074
 *       external/cwe/cwe-400
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.ExternalFlow
import DataFlow::PathGraph

private class ActivateModels extends ActiveExperimentalModels {
  ActivateModels() { this = "log4j-injection" }
}

/** A data flow sink for unvalidated user input that is used to log messages. */
class Log4jInjectionSink extends DataFlow::Node {
  Log4jInjectionSink() { sinkNode(this, "log4j") }
}

/**
 * A node that sanitizes a message before logging to avoid log injection.
 */
class Log4jInjectionSanitizer extends DataFlow::Node {
  Log4jInjectionSanitizer() {
    this.getType() instanceof BoxedType or this.getType() instanceof PrimitiveType
  }
}

/**
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
class Log4jInjectionConfiguration extends TaintTracking::Configuration {
  Log4jInjectionConfiguration() { this = "Log4jInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Log4jInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Log4jInjectionSanitizer }
}

from Log4jInjectionConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Log4j log entry depends on a $@.", source.getNode(),
  "user-provided value"
