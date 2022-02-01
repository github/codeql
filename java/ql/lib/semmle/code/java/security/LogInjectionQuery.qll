/** Provides taint tracking configurations to be used in queries related to the Log Injection vulnerability. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.LogInjection

/**
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
class LogInjectionConfiguration extends TaintTracking::Configuration {
  LogInjectionConfiguration() { this = "LogInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LogInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof LogInjectionSanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(LogInjectionAdditionalTaintStep c).step(node1, node2)
  }
}
