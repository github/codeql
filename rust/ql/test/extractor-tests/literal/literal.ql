import rust

query predicate charLiteral(CharLiteralExpr e) { any() }

query predicate stringLiteral(StringLiteralExpr e) { any() }

query predicate integerLiteral(IntegerLiteralExpr e, string suffix) {
  suffix = concat(e.getSuffix())
}

query predicate floatLiteral(FloatLiteralExpr e, string suffix) { suffix = concat(e.getSuffix()) }

query predicate booleanLiteral(BooleanLiteralExpr e) { any() }
