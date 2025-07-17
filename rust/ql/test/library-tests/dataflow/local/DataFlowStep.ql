import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.internal.DataFlowImpl
import codeql.rust.dataflow.internal.Node
import utils.test.TranslateModels

query predicate localStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  // Local flow steps that don't originate from a flow summary.
  RustDataFlow::simpleLocalFlowStep(nodeFrom, nodeTo, "")
}

class Node extends DataFlow::Node {
  Node() { not this instanceof FlowSummaryNode }
}

query predicate storeStep(Node node1, DataFlow::Content c, Node node2) {
  RustDataFlow::storeContentStep(node1, c, node2)
}

query predicate readStep(Node node1, DataFlow::Content c, Node node2) {
  RustDataFlow::readContentStep(node1, c, node2)
}
