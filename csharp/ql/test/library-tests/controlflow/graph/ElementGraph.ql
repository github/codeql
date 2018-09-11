import csharp

query predicate edges(ControlFlowElement node, ControlFlowElement successor, string attr, string val) {
  exists(ControlFlow::SuccessorType t |
    successor = node.getAControlFlowNode().getASuccessorByType(t).getElement() |
    attr = "semmle.label" and
    val = t.toString()
  )
}
