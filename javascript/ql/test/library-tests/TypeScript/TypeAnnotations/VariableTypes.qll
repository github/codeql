import javascript

query predicate test_VariableTypes(VarDecl var, string res0, TypeExpr res1) {
  res0 = var.getName() and res1 = var.getTypeAnnotation()
}
