/** Provides a taint-tracking configuration to reason about cross-site scripting from a local source. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.XSS

/**
 * A taint-tracking configuration for reasoning about cross-site scripting vulnerabilities from a local source.
 */
module XssLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }
}

/**
 * Taint-tracking flow for cross-site scripting vulnerabilities from a local source.
 */
module XssLocalFlow = TaintTracking::Global<XssLocalConfig>;
