import javascript

query predicate exprFloatValue(BigIntLiteral literal, float f) { f = literal.getFloatValue() }

query predicate exprIntValue(BigIntLiteral literal, int i) { i = literal.getIntValue() }

query predicate exprWithBigIntType(Expr e) { e.getType() instanceof BigIntType }

query predicate literalTypeExprIntValue(BigIntLiteralTypeExpr type, int val) {
  val = type.getIntValue()
}

query predicate typeExpr(TypeExpr type) { type.isBigInt() }

query predicate typeIntValue(BigIntLiteralType type, int i) { type.getIntValue() = i }
