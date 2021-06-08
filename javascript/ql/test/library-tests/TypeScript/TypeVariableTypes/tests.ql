import javascript

query predicate canonicalTypeVariableType(CanonicalTypeVariableType type, CanonicalName name) {
  type.getCanonicalName() = name
}

query predicate lexicalTypeVariableType(LexicalTypeVariableType type, string name) {
  type.getName() = name
}

string getBound(CallSignatureType sig, int n) {
  result = sig.getTypeParameterBound(n).toString()
  or
  not exists(sig.getTypeParameterBound(n)) and
  result = "no bound" and
  n = [0 .. sig.getNumTypeParameter() - 1]
}

query predicate signatureTypeParameters(
  CallSignatureType sig, int n, int numTypeParam, string paramName, string bound
) {
  sig.getNumTypeParameter() = numTypeParam and
  sig.getTypeParameterName(n) = paramName and
  bound = getBound(sig, n)
}

query predicate thisType(ThisType type, TypeReference enclosing) {
  type.getEnclosingType() = enclosing
}

query predicate typeVariableCanonicalNames(TypeVariableType type, CanonicalName name) {
  type.getCanonicalName() = name
}

query predicate typeVariableDecl(TypeVariableType tv, CanonicalName name, TypeParameter decl) {
  tv.getCanonicalName() = name and
  tv.getADeclaration() = decl
}

query predicate typeVariableHost(TypeVariableType type, CanonicalName name, TypeName hostType) {
  type.getCanonicalName() = name and
  type.getHostType() = hostType
}
