import csharp

query predicate edges(ControlFlowNode node, ControlFlowNode successor, string attr, string val) {
  not node.getAstNode().fromLibrary() and
  exists(ControlFlow::SuccessorType t | successor = node.getASuccessor(t) |
    attr = "semmle.label" and
    val = t.toString()
  )
}
