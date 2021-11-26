/** Provides taint tracking configurations to be used in OGNL injection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.OgnlInjection

/**
 * A taint-tracking configuration for unvalidated user input that is used in OGNL EL evaluation.
 */
class OgnlInjectionFlowConfig extends TaintTracking::Configuration {
  OgnlInjectionFlowConfig() { this = "OgnlInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof OgnlInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(OgnlInjectionAdditionalTaintStep c).step(node1, node2)
  }
}
