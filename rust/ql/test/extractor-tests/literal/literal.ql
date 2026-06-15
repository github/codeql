import rust
import TestUtils

query predicate charLiteral(CharLiteralExpr e) { toBeTested(e) }

query predicate stringLiteral(StringLiteralExpr e) { toBeTested(e) }

query predicate integerLiteral(IntegerLiteralExpr e, string suffix) {
  toBeTested(e) and suffix = concat(e.getSuffix())
}

query predicate floatLiteral(FloatLiteralExpr e, string suffix) {
  toBeTested(e) and suffix = concat(e.getSuffix())
}

query predicate booleanLiteral(BooleanLiteralExpr e) { toBeTested(e) }
