private import codeql.swift.generated.expr.KeyPathDotExpr

class KeyPathDotExpr extends KeyPathDotExprBase {
  override string toString() { result = "\\...." }
}
