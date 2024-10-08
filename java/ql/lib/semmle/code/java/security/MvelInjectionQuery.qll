/** Provides taint tracking configurations to be used in MVEL injection related queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.MvelInjection

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a MVEL expression.
 */
module MvelInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof MvelEvaluationSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof MvelInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(MvelInjectionAdditionalTaintStep c).step(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a MVEL expression. */
module MvelInjectionFlow = TaintTracking::Global<MvelInjectionFlowConfig>;
