import javascript

query predicate exprFloatValue(BigIntLiteral literal, float f) { f = literal.getFloatValue() }

query predicate exprIntValue(BigIntLiteral literal, int i) { i = literal.getIntValue() }

query predicate literalTypeExprIntValue(BigIntLiteralTypeExpr type, int val) {
  val = type.getIntValue()
}

query predicate typeExpr(TypeExpr type) { type.isBigInt() }
