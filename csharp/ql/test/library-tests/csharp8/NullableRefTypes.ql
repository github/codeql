import csharp

query predicate suppressNullableWarnings(SuppressNullableWarningExpr e, Expr op) {
  op = e.getExpr()
}

query predicate nullableDataFlow(DataFlow::Node src, DataFlow::Node sink) {
  src.getEnclosingCallable().hasName("TestNullableRefTypes") and
  DataFlow::localFlowStep(src, sink)
}

query predicate nullableControlFlow(
  ControlFlow::Node a, ControlFlow::Node b, ControlFlow::SuccessorType t
) {
  a.getEnclosingCallable().hasName("TestNullableRefTypes") and
  b = a.getASuccessorByType(t)
}
