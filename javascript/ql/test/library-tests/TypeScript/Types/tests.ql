import javascript

// Ensure `true | false` and `false | true` are not distinct boolean types.
query predicate booleans(BooleanType t) { any() }

query Type getExprType(Expr expr) { result = expr.getType() }

query Type getTypeDefinitionType(TypeDefinition def) { result = def.getType() }

query Type getTypeExprType(TypeExpr e) { result = e.getType() }

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

query CallSignatureType abstractSignature() { result.isAbstract() }

query UnionType unionIndex(Type element, int i) { result.getElementType(i) = element }

query BlockStmt getAStaticInitializerBlock(ClassDefinition cls) {
  result = cls.getAStaticInitializerBlock()
}
