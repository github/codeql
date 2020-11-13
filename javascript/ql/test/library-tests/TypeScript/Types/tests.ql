import javascript

// Ensure `true | false` and `false | true` are not distinct boolean types.
query predicate booleans(BooleanType t) { any() }

query predicate getExprType(Expr expr, Type type) { type = expr.getType() }

query predicate getTypeDefinitionType(TypeDefinition def, Type type) { type = def.getType() }

query predicate getTypeExprType(TypeExpr e, Type type) { e.getType() = type }

query predicate missingToString(Type typ, string msg) {
  not exists(typ.toString()) and
  msg = "Missing toString for " + typ.getAQlClass()
}

query predicate referenceDefinition(TypeReference ref, TypeDefinition def) {
  def = ref.getADefinition()
}

string getRest(TupleType tuple) {
  if tuple.hasRestElement()
  then result = tuple.getRestElementType().toString()
  else result = "no-rest"
}

query predicate tupleTypes(Expr e, TupleType tuple, int n, Type element, int minLength, string rest) {
  e.getType() = tuple and
  element = tuple.getElementType(n) and
  minLength = tuple.getMinimumLength() and
  rest = getRest(tuple)
}

query predicate unknownType(Expr e, Type type) {
  type = e.getType() and
  e.getType() instanceof UnknownType
}
