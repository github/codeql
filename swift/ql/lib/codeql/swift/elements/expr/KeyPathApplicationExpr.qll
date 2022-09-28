private import codeql.swift.generated.expr.KeyPathApplicationExpr

class KeyPathApplicationExpr extends KeyPathApplicationExprBase {
  override string toString() { result = "\\...[...]" }
}
