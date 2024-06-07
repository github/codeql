private import codeql.swift.generated.expr.UnresolvedDotExpr

class UnresolvedDotExpr extends Generated::UnresolvedDotExpr {
  override string toString() { result = "... ." + this.getName() }
}
