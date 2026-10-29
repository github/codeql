import javascript

query predicate test_CallSignature(
  CallSignature call, string declType, AstNode body, string abstractness
) {
  (if call.isAbstract() then abstractness = "abstract" else abstractness = "not abstract") and
  declType = call.getDeclaringType().describe() and
  body = call.getBody()
}

query predicate test_IndexSignature(
  IndexSignature sig, string declType, AstNode body, string abstractness
) {
  (if sig.isAbstract() then abstractness = "abstract" else abstractness = "not abstract") and
  declType = sig.getDeclaringType().describe() and
  body = sig.getBody()
}

query predicate test_MethodDeclarations(MethodDeclaration method, string descr) {
  descr = "Method " + method.getName() + " in " + method.getDeclaringType().describe()
}

query predicate test_MethodOverload(MethodDeclaration method, int index, boolean overloaded) {
  index = method.getOverloadIndex() and
  if method.isOverloaded() then overloaded = true else overloaded = false
}

query predicate test_FunctionCallSigOverload(
  FunctionCallSignature sig, int index, boolean overloaded
) {
  index = sig.getOverloadIndex() and
  if sig.isOverloaded() then overloaded = true else overloaded = false
}

query predicate test_ConstructorCallSigOverload(
  ConstructorCallSignature sig, int index, boolean overloaded
) {
  index = sig.getOverloadIndex() and
  if sig.isOverloaded() then overloaded = true else overloaded = false
}
