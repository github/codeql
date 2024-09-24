/** Provides a taint tracking configuration for server-side template injection (SST) vulnerabilities */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.TemplateInjection

/** A taint tracking configuration to reason about server-side template injection (SST) vulnerabilities */
module TemplateInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof TemplateInjectionSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof TemplateInjectionSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof TemplateInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(TemplateInjectionAdditionalTaintStep a).isAdditionalTaintStep(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks server-side template injection (SST) vulnerabilities */
module TemplateInjectionFlow = TaintTracking::Global<TemplateInjectionFlowConfig>;
