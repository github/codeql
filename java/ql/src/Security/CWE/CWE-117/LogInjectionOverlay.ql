/**
 * @name Log Injection
 * @description Building log entries from user-controlled data may allow
 *              insertion of forged log entries by malicious users.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id java/log-injection
 * @tags security
 *       external/cwe/cwe-117
 */

// import java
base import semmle.code.java.dataflow.FlowSources as BaseFlowSources
base import semmle.code.java.security.LogInjection as BaseLogInjection
overlay import semmle.code.java.dataflow.FlowSources as OverlayFlowSources
overlay import semmle.code.java.security.LogInjection as OverlayLogInjection
import semmle.code.java.dataflow.OverlayDataFlow

/**
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
module LogInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asBase() instanceof BaseFlowSources::ThreatModelFlowSource and
    exists(OverlayLogInjection::LogInjectionSink sink)
    or
    source.asOverlay() instanceof OverlayFlowSources::ThreatModelFlowSource
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asBase() instanceof BaseLogInjection::LogInjectionSink and
    exists(OverlayFlowSources::ThreatModelFlowSource source)
    or
    sink.asOverlay() instanceof OverlayLogInjection::LogInjectionSink
  }

  predicate isBarrier(DataFlow::Node node) {
    node.asBase() instanceof BaseLogInjection::LogInjectionSanitizer or
    node.asOverlay() instanceof OverlayLogInjection::LogInjectionSanitizer
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(BaseLogInjection::LogInjectionAdditionalTaintStep c).step(node1.asBase(), node2.asBase()) or
    any(OverlayLogInjection::LogInjectionAdditionalTaintStep c)
        .step(node1.asOverlay(), node2.asOverlay())
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * Taint-tracking flow for tracking untrusted user input used in log entries.
 */
module LogInjectionFlow = TaintTracking::Global<LogInjectionConfig>;

import LogInjectionFlow::PathGraph

from LogInjectionFlow::PathNode source, LogInjectionFlow::PathNode sink
where LogInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This log entry depends on a $@.", source.getNode(),
  "user-provided value"
