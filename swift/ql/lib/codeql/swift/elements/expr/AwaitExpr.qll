private import codeql.swift.generated.expr.AwaitExpr

class AwaitExpr extends AwaitExprBase {
  override string toString() { result = "await ..." }
}
