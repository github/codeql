private import codeql.swift.generated.expr.KeyPathExpr

class KeyPathExpr extends KeyPathExprBase {
  override string toString() { result = "#keyPath(...)" }
}
