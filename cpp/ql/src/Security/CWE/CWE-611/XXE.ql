/**
 * @name XML external entity expansion
 * @description Parsing user-controlled XML documents and allowing expansion of
 *              external entity references may lead to disclosure of
 *              confidential data or denial of service.
 * @kind path-problem
 * @id cpp/external-entity-expansion
 * @problem.severity warning
 * @security-severity 9.1
 * @precision high
 * @tags security
 *       external/cwe/cwe-611
 */

import cpp
import XML
import DataFlow::PathGraph

/**
 * A configuration for tracking XML objects and their states.
 */
class XXEConfiguration extends DataFlow::Configuration {
  XXEConfiguration() { this = "XXEConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    any(XmlLibrary l).configurationSource(node, flowstate)
  }

  override predicate isSink(DataFlow::Node node, string flowstate) {
    any(XmlLibrary l).configurationSink(node, flowstate)
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, string state1, DataFlow::Node node2, string state2
  ) {
    // create additional flow steps for `XxeFlowStateTransformer`s
    state2 = node2.asConvertedExpr().(XxeFlowStateTransformer).transform(state1) and
    DataFlow::simpleLocalFlowStep(node1, node2)
  }

  override predicate isBarrier(DataFlow::Node node, string flowstate) {
    // when the flowstate is transformed at a call node, block the original
    // flowstate value.
    node.asConvertedExpr().(XxeFlowStateTransformer).transform(flowstate) != flowstate
  }
}

from XXEConfiguration conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink,
  "This $@ is not configured to prevent an XML external entity (XXE) attack.", source, "XML parser"
