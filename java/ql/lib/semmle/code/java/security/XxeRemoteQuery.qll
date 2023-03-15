/** Provides taint tracking configurations to be used in remote XXE queries. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.XxeQuery

/**
 * DEPRECATED: Use `XxeFlow` instead.
 *
 * A taint-tracking configuration for unvalidated remote user input that is used in XML external entity expansion.
 */
deprecated class XxeConfig extends TaintTracking::Configuration {
  XxeConfig() { this = "XxeConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XxeSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof XxeSanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(XxeAdditionalTaintStep s).step(n1, n2)
  }
}

private module XxeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof XxeSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof XxeSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(XxeAdditionalTaintStep s).step(n1, n2)
  }
}

module XxeFlow = TaintTracking::Make<XxeConfig>;
