import csharp

query predicate edges(ControlFlowNode n1, ControlFlowNode n2, string attr, string val) {
  exists(SwitchStmt switch, ControlFlow::SuccessorType t |
    switch.getControlFlowNode().getASuccessor*() = n1
  |
    n2 = n1.getASuccessor(t) and
    attr = "semmle.label" and
    val = t.toString()
  )
}
