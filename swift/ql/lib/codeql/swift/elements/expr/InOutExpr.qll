private import codeql.swift.generated.expr.InOutExpr

class InOutExpr extends Generated::InOutExpr {
  override string toString() { result = "&..." }
}
