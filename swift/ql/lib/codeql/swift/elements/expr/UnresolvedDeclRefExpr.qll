private import codeql.swift.generated.expr.UnresolvedDeclRefExpr

class UnresolvedDeclRefExpr extends UnresolvedDeclRefExprBase {
  override string toString() {
    result = getName() + " (unresolved)"
    or
    not hasName() and result = "(unresolved)"
  }
}
