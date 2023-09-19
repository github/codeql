import csharp

query predicate edges(ControlFlow::Node node, ControlFlow::Node successor, string attr, string val) {
  not node.getAstNode().fromLibrary() and
  exists(ControlFlow::SuccessorType t | successor = node.getASuccessorByType(t) |
    attr = "semmle.label" and
    val = t.toString()
  )
}
