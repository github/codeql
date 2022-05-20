import csharp

query predicate edges(ControlFlow::Node a, ControlFlow::Node b, string label, string value) {
  exists(ControlFlow::SuccessorType t |
    a.getEnclosingCallable().getName().matches("Expressions%") and
    b = a.getASuccessorByType(t) and
    label = "semmle.label" and
    value = t.toString()
  )
}
