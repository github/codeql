/** Provides taint-tracking flow to reason about XPath injection queries. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.XPath

/**
 * A taint-tracking configuration for reasoning about XPath injection vulnerabilities.
 */
module XPathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking flow for XPath injection vulnerabilities.
 */
module XPathInjectionFlow = TaintTracking::Global<XPathInjectionConfig>;
