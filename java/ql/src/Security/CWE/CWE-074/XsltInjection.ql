/**
 * @name XSLT transformation with user-controlled stylesheet
 * @description Doing an XSLT transformation with user-controlled stylesheet can lead to
 *              information disclosure or execution of arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/xslt-injection
 * @tags security
 *       external/cwe/cwe-074
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XsltInjection
import DataFlow::PathGraph

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

from DataFlow::PathNode source, DataFlow::PathNode sink, XsltInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "XSLT transformation might include stylesheet from $@.",
  source.getNode(), "this user input"
