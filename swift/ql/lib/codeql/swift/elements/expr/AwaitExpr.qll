private import codeql.swift.generated.expr.AwaitExpr

class AwaitExpr extends Generated::AwaitExpr {
  override string toString() { result = "await ..." }
}
