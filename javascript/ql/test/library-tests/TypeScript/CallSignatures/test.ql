import javascript

query predicate test_CallSignature(CallSignature call, string declType, ASTNode body, string abstractness) {
  (if call.isAbstract() then abstractness = "abstract" else abstractness = "not abstract") and
  declType = call.getDeclaringType().describe() and
  body = call.getBody()
}

query predicate test_IndexSignature(IndexSignature sig, string declType, ASTNode body, string abstractness) {
  (if sig.isAbstract() then abstractness = "abstract" else abstractness = "not abstract") and
  declType = sig.getDeclaringType().describe() and
  body = sig.getBody()
}

query predicate test_MethodDeclarations(MethodDeclaration method, string descr) {
  descr = "Method " + method.getName() + " in " + method.getDeclaringType().describe()
}
