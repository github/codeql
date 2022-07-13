private import codeql.swift.generated.expr.NilLiteralExpr

class NilLiteralExpr extends NilLiteralExprBase {
  override string toString() { result = "nil" }
}
