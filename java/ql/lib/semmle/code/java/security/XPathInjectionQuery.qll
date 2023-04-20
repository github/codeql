/** Provides taint-tracking flow to reason about XPath injection queries. */

import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.XPath

/**
 * A taint-tracking configuration for reasoning about XPath injection vulnerabilities.
 */
module XPathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }
}

/**
 * Taint-tracking flow for XPath injection vulnerabilities.
 */
module XPathInjectionFlow = TaintTracking::Global<XPathInjectionConfig>;
