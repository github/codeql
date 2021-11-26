import python
import semmle.python.dataflow.new.DataFlow

query DataFlow::Node moduleVariables() { result instanceof DataFlow::ModuleVariableNode }

query predicate reads(DataFlow::Node fromNode, DataFlow::Node toNode) {
  fromNode.(DataFlow::ModuleVariableNode).getARead() = toNode
}

query predicate writes(DataFlow::Node fromNode, DataFlow::Node toNode) {
  fromNode = toNode.(DataFlow::ModuleVariableNode).getAWrite()
}
