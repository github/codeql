/**
 * @name Log Injection
 * @description Building log entries from user-controlled data is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/log-injection
 * @tags security
 *       external/cwe/cwe-117
 */

import java
import DataFlow::PathGraph
import experimental.semmle.code.java.Logging
import semmle.code.java.dataflow.FlowSources

/**
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
private class LogInjectionConfiguration extends TaintTracking::Configuration {
  LogInjectionConfiguration() { this = "Log Injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(LoggingCall c).getALogArgument()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof BoxedType or node.getType() instanceof PrimitiveType
  }
}

from LogInjectionConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to log entry.", source.getNode(),
  "User-provided value"
