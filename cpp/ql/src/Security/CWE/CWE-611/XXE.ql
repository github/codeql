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
import XxeFlow::PathGraph

/**
 * A configuration for tracking XML objects and their states.
 */
module XxeConfig implements DataFlow::StateConfigSig {
  class FlowState = TXxeFlowState;

  predicate isSource(DataFlow::Node node, FlowState flowstate) {
    any(XmlLibrary l).configurationSource(node, flowstate)
  }

  predicate isSink(DataFlow::Node node, FlowState flowstate) {
    any(XmlLibrary l).configurationSink(node, flowstate)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    // create additional flow steps for `XxeFlowStateTransformer`s
    state2 = node2.asIndirectExpr().(XxeFlowStateTransformer).transform(state1) and
    DataFlow::simpleLocalFlowStep(node1, node2, _)
  }

  predicate isBarrier(DataFlow::Node node, FlowState flowstate) {
    // when the flowstate is transformed at a call node, block the original
    // flowstate value.
    node.asIndirectExpr().(XxeFlowStateTransformer).transform(flowstate) != flowstate
  }

  predicate neverSkip(DataFlow::Node node) { none() }
}

module XxeFlow = DataFlow::GlobalWithState<XxeConfig>;

from XxeFlow::PathNode source, XxeFlow::PathNode sink
where XxeFlow::flowPath(source, sink)
select sink, source, sink,
  "This $@ is not configured to prevent an XML external entity (XXE) attack.", source, "XML parser"
