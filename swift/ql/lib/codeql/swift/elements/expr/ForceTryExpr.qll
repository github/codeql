private import codeql.swift.generated.expr.ForceTryExpr

class ForceTryExpr extends Generated::ForceTryExpr {
  override string toString() { result = "try! ..." }
}
