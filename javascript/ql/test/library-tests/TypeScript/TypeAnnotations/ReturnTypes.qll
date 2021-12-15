import javascript

query predicate test_ReturnTypes(Function function, string res0, TypeExpr res1) {
  res0 = function.describe() and res1 = function.getReturnTypeAnnotation()
}
