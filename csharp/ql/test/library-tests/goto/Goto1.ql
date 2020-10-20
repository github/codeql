import csharp

query predicate edges(ControlFlow::Node node, ControlFlow::Node successor, string attr, string val) {
  exists(ControlFlow::SuccessorType t |
    successor = node.getASuccessorByType(t) and
    (node.getElement().fromSource() or successor.getElement().fromSource())
  |
    attr = "semmle.label" and
    val = t.toString()
  )
}
