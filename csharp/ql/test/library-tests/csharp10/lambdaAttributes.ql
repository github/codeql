import csharp

query predicate allAttributes(Attribute a, Expr arg, string c) {
  a.fromSource() and
  arg = a.getArgument(0) and
  c = a.getTarget().(Element).getAPrimaryQlClass()
}

query predicate lambdaAttributes(Attribute a, Expr arg, LambdaExpr l) {
  allAttributes(a, arg, _) and a.getTarget() = l
}
