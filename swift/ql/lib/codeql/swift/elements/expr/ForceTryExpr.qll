private import codeql.swift.generated.expr.ForceTryExpr

class ForceTryExpr extends ForceTryExprBase {
  override string toString() { result = "try! ..." }
}
