private import codeql.swift.generated.expr.ParenExpr

class ParenExpr extends Generated::ParenExpr {
  override string toString() { result = "(...)" }
}
