import csharp

private string printExpr(Expr e) {
  e =
    any(SubExpr sub |
      result = sub.getLeftOperand().toString() + " - " + sub.getRightOperand().toString()
    )
  or
  not e instanceof SubExpr and
  result = e.toString()
}

query predicate methodCalls(MethodCall mc, string m, int i, string arg) {
  m = mc.getTarget().toStringWithTypes() and
  arg = printExpr(mc.getArgument(i))
}

query predicate propertyCalls(PropertyCall p, Expr qualifier) { qualifier = p.getQualifier() }
