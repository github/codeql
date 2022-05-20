import javascript

query predicate test_FunctionTypeParameters(FunctionTypeExpr type, int n, int res0, Parameter res1) {
  res0 = type.getNumParameter() and res1 = type.getParameter(n)
}
