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
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.security.Sanitizers
import Log4jInjectionFlow::PathGraph

deprecated private class ActivateModels extends ActiveExperimentalModels {
  ActivateModels() { this = "log4j-injection" }
}

/** A data flow sink for unvalidated user input that is used to log messages. */
class Log4jInjectionSink extends DataFlow::Node {
  Log4jInjectionSink() { sinkNode(this, "log4j") }
}

/**
 * A node that sanitizes a message before logging to avoid log injection.
 */
class Log4jInjectionSanitizer extends DataFlow::Node instanceof SimpleTypeSanitizer { }

/**
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
module Log4jInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Log4jInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Log4jInjectionSanitizer }
}

/**
 * Taint-tracking flow for tracking untrusted user input used in log entries.
 */
module Log4jInjectionFlow = TaintTracking::Global<Log4jInjectionConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, Log4jInjectionFlow::PathNode source, Log4jInjectionFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  Log4jInjectionFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Log4j log entry depends on a $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
