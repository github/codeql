/** Provides taint tracking configurations to be used in XSLT injection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.XsltInjection

/**
 * A taint-tracking configuration for unvalidated user input that is used in XSLT transformation.
 */
class XsltInjectionFlowConfig extends TaintTracking::Configuration {
  XsltInjectionFlowConfig() { this = "XsltInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XsltInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(XsltInjectionAdditionalTaintStep c).step(node1, node2)
  }
}
