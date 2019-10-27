import javascript

string getASignatureOrElseType(Type t) {
  result = t.getASignature(_).toString()
  or
  not exists(t.getASignature(_)) and
  result = t.toString()
}

query predicate test_ExprSignature(Expr expr, string type) {
  not exists(MethodDeclaration decl | decl.getNameExpr() = expr) and
  not exists(DotExpr dot | expr = dot.getPropertyNameExpr()) and
  type = getASignatureOrElseType(expr.getType())
}

query predicate test_TypeReferenceSig(TypeReference type, SignatureKind kind, int n, CallSignatureType sig) {
  sig = type.getSignature(kind, n)
}

query predicate test_FunctionCallSig(Function f, CallSignatureType sig) {
  sig = f.getCallSignature()
}
