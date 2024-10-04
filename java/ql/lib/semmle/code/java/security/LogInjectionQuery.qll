/** Provides taint tracking configurations to be used in queries related to the Log Injection vulnerability. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.LogInjection

/**
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
module LogInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof LogInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof LogInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(LogInjectionAdditionalTaintStep c).step(node1, node2)
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * Taint-tracking flow for tracking untrusted user input used in log entries.
 */
module LogInjectionFlow = TaintTracking::Global<LogInjectionConfig>;
