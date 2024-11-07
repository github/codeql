/** Provides taint tracking configurations to be used in local XXE queries. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.XxeQuery

/**
 * A taint-tracking configuration for unvalidated local user input that is used in XML external entity expansion.
 */
deprecated module XxeLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof XxeSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof XxeSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(XxeAdditionalTaintStep s).step(n1, n2)
  }
}

/**
 * DEPRECATED: Use `XxeFlow` instead and configure threat model sources to include `local`.
 *
 * Detect taint flow of unvalidated local user input that is used in XML external entity expansion.
 */
deprecated module XxeLocalFlow = TaintTracking::Global<XxeLocalConfig>;
