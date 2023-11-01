/**
 * Provides a taint-tracking configuration for detecting "XSLT injection" vulnerabilities.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import XsltInjectionCustomizations::XsltInjection
import XsltConcept

module XsltInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // I considered using a FlowState of (raw-string, ElementTree), but in all honesty
    // valid code would never have direct flow from a string to a sink anyway... so I
    // opted for the more simple approach.
    nodeTo = elementTreeConstruction(nodeFrom)
  }
}

module XsltInjectionFlow = TaintTracking::Global<XsltInjectionConfig>;
