import csharp

query predicate edges(ControlFlowNode a, ControlFlowNode b, string label, string value) {
  exists(ControlFlow::SuccessorType t |
    a.getEnclosingCallable().getName() = "IsPatterns" and
    b = a.getASuccessor(t) and
    label = "semmle.label" and
    value = t.toString()
  )
}
