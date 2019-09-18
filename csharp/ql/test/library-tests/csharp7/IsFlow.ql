import csharp

query predicate edges(ControlFlow::Node n1, ControlFlow::Node n2, string attr, string val) {
  exists(SwitchStmt switch, ControlFlow::SuccessorType t |
    switch.getAControlFlowNode().getASuccessor*() = n1
  |
    n2 = n1.getASuccessorByType(t) and
    attr = "semmle.label" and
    val = t.toString()
  )
}
