/** Provides a taint tracking configuration for server-side template injection (SST) vulnerabilities */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.TemplateInjection

/**
 * DEPRECATED: Use `TemplateInjectionFlow` instead.
 *
 * A taint tracking configuration to reason about server-side template injection (SST) vulnerabilities
 */
deprecated class TemplateInjectionFlowConfig extends TaintTracking::Configuration {
  TemplateInjectionFlowConfig() { this = "TemplateInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.(TemplateInjectionSource).hasState(state)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink.(TemplateInjectionSink).hasState(state)
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof TemplateInjectionSanitizer
  }

  override predicate isSanitizer(DataFlow::Node sanitizer, DataFlow::FlowState state) {
    sanitizer.(TemplateInjectionSanitizerWithState).hasState(state)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(TemplateInjectionAdditionalTaintStep a).isAdditionalTaintStep(node1, node2)
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    any(TemplateInjectionAdditionalTaintStep a).isAdditionalTaintStep(node1, state1, node2, state2)
  }
}

/** A taint tracking configuration to reason about server-side template injection (SST) vulnerabilities */
module TemplateInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof TemplateInjectionSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof TemplateInjectionSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof TemplateInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(TemplateInjectionAdditionalTaintStep a).isAdditionalTaintStep(node1, node2)
  }
}

/** Tracks server-side template injection (SST) vulnerabilities */
module TemplateInjectionFlow = TaintTracking::Global<TemplateInjectionFlowConfig>;
