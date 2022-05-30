private import codeql.swift.generated.expr.SuperRefExpr

class SuperRefExpr extends SuperRefExprBase {
  override string toString() { result = "super" }
}
