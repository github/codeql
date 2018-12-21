import csharp
import Common

query predicate edges(
  SourceControlFlowElement node, SourceControlFlowElement successor, string attr, string val
) {
  exists(ControlFlow::SuccessorType t |
    successor = node.getAControlFlowNode().getASuccessorByType(t).getElement()
  |
    attr = "semmle.label" and
    val = t.toString()
  )
}
