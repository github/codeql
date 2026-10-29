import javascript

query predicate test_ThisParameterTypes(string res0, TypeExpr res1) {
  exists(Function function | res0 = function.describe() and res1 = function.getThisTypeAnnotation())
}
