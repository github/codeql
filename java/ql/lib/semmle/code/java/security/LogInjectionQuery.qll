/** Provides taint tracking configurations to be used in queries related to the Log Injection vulnerability. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.LogInjection

/**
 * DEPRECATED: Use `LogInjectionFlow` instead.
 *
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
deprecated class LogInjectionConfiguration extends TaintTracking::Configuration {
  LogInjectionConfiguration() { this = "LogInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LogInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof LogInjectionSanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(LogInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

private module LogInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof LogInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof LogInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(LogInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

/**
 * Taint-tracking flow for tracking untrusted user input used in log entries.
 */
module LogInjectionFlow = TaintTracking::Make<LogInjectionConfig>;
