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

query predicate test_TypeReferenceSig(
  TypeReference type, SignatureKind kind, int n, CallSignatureType sig
) {
  sig = type.getSignature(kind, n)
}

query predicate test_FunctionCallSig(Function f, CallSignatureType sig) {
  sig = f.getCallSignature()
}

query Type test_getRestParameterType(CallSignatureType sig) { result = sig.getRestParameterType() }

query Type test_getRestParameterArray(CallSignatureType sig) {
  result = sig.getRestParameterArrayType()
}

query predicate test_RestSig_getParameter(CallSignatureType sig, int n, string name, Type type) {
  sig.hasRestParameter() and
  name = sig.getParameterName(n) and
  type = sig.getParameter(n)
}

query int test_RestSig_numRequiredParams(CallSignatureType sig) {
  sig.hasRestParameter() and
  result = sig.getNumRequiredParameter()
}
