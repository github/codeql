import csharp

query predicate edges(ControlFlowNode node1, ControlFlowNode node2, string label, string value) {
  label = "semmle.label" and
  exists(ControlFlow::SuccessorType t | node2 = node1.getASuccessor(t) and value = t.toString()) and
  node1.getEnclosingCallable().hasName("TestUsingDeclarations")
}
