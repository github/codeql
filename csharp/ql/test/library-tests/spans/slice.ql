import csharp

private string printExpr(Expr e) {
  e = any(IndexExpr index | result = "^" + index.getExpr().toString())
  or
  not e instanceof IndexExpr and
  result = e.toString()
}

query predicate methodArguments(MethodCall mc, string target, int i, string arg) {
  target = mc.getTarget().toStringWithTypes() and
  arg = printExpr(mc.getArgument(i))
}

query predicate methodCalls(MethodCall mc, string target) {
  target = mc.getTarget().toStringWithTypes()
}
