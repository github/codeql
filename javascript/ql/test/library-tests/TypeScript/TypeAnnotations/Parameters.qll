import javascript

query predicate test_Parameters(Parameter p, Expr res0, TypeExpr res1) {
  res0 = p.getDefault() and res1 = p.getTypeAnnotation()
}
