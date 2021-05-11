/**
 * @name OGNL Expression Language statement with user-controlled input
 * @description Evaluation of OGNL Expression Language statement with user-controlled input can
 *                lead to execution of arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/ognl-injection
 * @tags security
 *       external/cwe/cwe-917
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph
import OgnlInjectionLib

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

from DataFlow::PathNode source, DataFlow::PathNode sink, OgnlInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "OGNL expression might include input from $@.",
  source.getNode(), "this user input"
