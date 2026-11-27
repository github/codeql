import utils.test.InlineFlowTest
import ValueFlowTest<DefaultFlowConfig>
private import semmle.go.dataflow.internal.VariableCapture as Capture
private import semmle.go.dataflow.internal.DataFlowUtil as Util
private import semmle.go.dataflow.internal.DataFlowNodes::Private as Nodes
private import semmle.go.dataflow.internal.DataFlowPrivate as PrivateFlow

query predicate spuriousConstructionClearing(DataFlow::Node construction, string variable) {
  construction.asExpr() instanceof FuncLit and
  exists(Util::CapturedVariableContent content |
    Capture::clearsContent(construction, content) and
    variable = content.getVariable().getName()
  )
}

query predicate exposedCaptureNode(string relation, DataFlow::Node node) {
  (
    node instanceof Nodes::CaptureNode or
    node instanceof Nodes::CapturedVariablesParameterNode
  ) and
  (
    relation = "flow" and
    (DataFlow::localFlowStep(node, _) or DataFlow::localFlowStep(_, node))
    or
    relation = "taint" and
    (TaintTracking::localTaintStep(node, _) or TaintTracking::localTaintStep(_, node))
  )
}

query predicate ambiguousCapturePostUpdate(DataFlow::PostUpdateNode node) {
  node instanceof Nodes::CaptureNode and
  node.toString() = node.getPreUpdateNode().toString()
}

query predicate unscopedCaptureNode(Nodes::CaptureNode node) {
  not exists(PrivateFlow::NodeRegion region |
    region.contains(node) and
    region.(BasicBlock).getScope() = node.getRoot()
  )
}
