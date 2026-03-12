import csharp

query predicate edges(ControlFlowNode n1, ControlFlowNode n2, string attr, string val) {
  exists(SwitchStmt switch, ControlFlow::SuccessorType t |
    switch.getAControlFlowNode().getASuccessor*() = n1
  |
    n2 = n1.getASuccessorByType(t) and
    attr = "semmle.label" and
    val = t.toString()
  )
}
