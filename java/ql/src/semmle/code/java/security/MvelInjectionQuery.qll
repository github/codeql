/** Provides taint tracking configurations to be used in MVEL injection related queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.MvelInjection

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a MVEL expression.
 */
class MvelInjectionFlowConfig extends TaintTracking::Configuration {
  MvelInjectionFlowConfig() { this = "MvelInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof MvelEvaluationSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof MvelInjectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(MvelInjectionAdditionalTaintStep c).step(node1, node2)
  }
}
