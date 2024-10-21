/** Provides taint tracking configurations to be used in OGNL injection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.OgnlInjection
private import semmle.code.java.security.Sanitizers

/**
 * A taint-tracking configuration for unvalidated user input that is used in OGNL EL evaluation.
 */
module OgnlInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof OgnlInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof SimpleTypeSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(OgnlInjectionAdditionalTaintStep c).step(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow of unvalidated user input that is used in OGNL EL evaluation. */
module OgnlInjectionFlow = TaintTracking::Global<OgnlInjectionFlowConfig>;
