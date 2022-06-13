private import codeql.swift.generated.expr.InterpolatedStringLiteralExpr

class InterpolatedStringLiteralExpr extends InterpolatedStringLiteralExprBase {
  override string toString() { result = "\"...\"" }
}
