private import codeql.swift.generated.expr.KeyPathExpr

class KeyPathExpr extends Generated::KeyPathExpr {
  override string toString() { result = "#keyPath(...)" }
}
