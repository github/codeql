/** Provides a taint tracking configuration to track cross site scripting. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.XSS

/**
 * A taint-tracking configuration for cross site scripting vulnerabilities.
 */
module XssConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof XssSanitizer }

  predicate isBarrierOut(DataFlow::Node node) { node instanceof XssSinkBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(XssAdditionalTaintStep s).step(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow from remote sources to cross site scripting vulnerabilities. */
module XssFlow = TaintTracking::Global<XssConfig>;
