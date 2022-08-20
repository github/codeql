private import codeql.swift.generated.expr.UnresolvedDotExpr

class UnresolvedDotExpr extends UnresolvedDotExprBase {
  override string toString() { result = "... ." + getName() }
}
