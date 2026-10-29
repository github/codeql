import python
import semmle.python.dataflow.new.DataFlow

query predicate parameterWithoutNode(Parameter p, string msg) {
  not exists(DataFlow::ParameterNode node | p = node.getParameter()) and
  msg = "There is no `ParameterNode` associated with this parameter."
}
