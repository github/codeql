/** Provides taint tracking configurations to be used in remote XXE queries. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.XxeQuery

/**
 * A taint-tracking configuration for unvalidated remote user input that is used in XML external entity expansion.
 */
module XxeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof XxeSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof XxeSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(XxeAdditionalTaintStep s).step(n1, n2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Detect taint flow of unvalidated remote user input that is used in XML external entity expansion.
 */
module XxeFlow = TaintTracking::Global<XxeConfig>;
