import csharp

query predicate edges(ControlFlow::Node node1, ControlFlow::Node node2, string label, string value) {
  label = "semmle.label" and
  exists(ControlFlow::SuccessorType t |
    node2 = node1.getASuccessorByType(t) and value = t.toString()
  ) and
  node1.getEnclosingCallable().hasName("TestUsingDeclarations")
}
