import javascript

query predicate bounds(TypeParameter param, TypeExpr bound) { param.getBound() = bound }

query predicate classOrInterfaceTypeParameters(
  ClassOrInterface ci, int n, int numParam, TypeParameter param
) {
  ci.getNumTypeParameter() = numParam and
  param = ci.getTypeParameter(n)
}

query predicate defaults(TypeParameter param, TypeExpr default) { default = param.getDefault() }

query predicate functionTypeParameters(Function f, int n, int numParam, TypeParameter param) {
  f.getNumTypeParameter() = numParam and
  param = f.getTypeParameter(n)
}

query predicate resolution(TypeParameter parameter, Identifier access, string msg) {
  parameter.getLocalTypeName().getAnAccess() = access and
  msg = "refers to " + parameter.getName() + " on " + parameter.getHost().describe()
}

query predicate typeParameters(TypeParameter param, Identifier id, string name) {
  param.getIdentifier() = id and
  param.getName() = name
}
