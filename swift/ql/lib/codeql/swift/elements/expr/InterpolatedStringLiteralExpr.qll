private import codeql.swift.generated.expr.InterpolatedStringLiteralExpr

class InterpolatedStringLiteralExpr extends Generated::InterpolatedStringLiteralExpr {
  override string toString() { result = "\"...\"" }
}
