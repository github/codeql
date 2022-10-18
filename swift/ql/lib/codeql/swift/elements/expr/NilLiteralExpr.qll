private import codeql.swift.generated.expr.NilLiteralExpr

class NilLiteralExpr extends Generated::NilLiteralExpr {
  override string toString() { result = "nil" }
}
