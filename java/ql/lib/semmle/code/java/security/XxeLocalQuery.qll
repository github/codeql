/** Provides taint tracking configurations to be used in local XXE queries. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.XxeQuery

/**
 * DEPRECATED: Use `XxeLocalFlow` instead.
 *
 * A taint-tracking configuration for unvalidated local user input that is used in XML external entity expansion.
 */
deprecated class XxeLocalConfig extends TaintTracking::Configuration {
  XxeLocalConfig() { this = "XxeLocalConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XxeSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof XxeSanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(XxeAdditionalTaintStep s).step(n1, n2)
  }
}

private module XxeLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof XxeSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof XxeSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(XxeAdditionalTaintStep s).step(n1, n2)
  }
}

module XxeLocalFlow = TaintTracking::Make<XxeLocalConfig>;
