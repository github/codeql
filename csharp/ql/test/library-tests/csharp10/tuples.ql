import csharp

private predicate relevant(Element e) { e.getFile().getBaseName() = "Tuples.cs" }

query predicate declarations(LocalVariableDeclExpr d) {
  relevant(d) and
  d.getParent*() instanceof TupleExpr
}

query predicate assignments(AssignableDefinitions::TupleAssignmentDefinition t, Assignable a, int o) {
  relevant(t.getAssignment()) and
  a = t.getTarget() and
  o = t.getEvaluationOrder()
}
