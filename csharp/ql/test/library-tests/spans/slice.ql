import csharp

private string printExpr(Expr e) {
  e = any(IndexExpr index | result = "^" + index.getExpr().toString())
  or
  not e instanceof IndexExpr and
  result = e.toString()
}

query predicate methodCalls(MethodCall mc, string m, int i, string arg) {
  m = mc.getTarget().toStringWithTypes() and
  arg = printExpr(mc.getArgument(i))
}
