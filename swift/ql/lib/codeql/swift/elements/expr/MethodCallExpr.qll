private import codeql.swift.elements.expr.CallExpr
private import codeql.swift.elements.expr.ApplyExpr
private import codeql.swift.elements.expr.SuperRefExpr
private import codeql.swift.elements.expr.SelfRefExpr

class MethodCallExpr extends CallExpr, MethodApplyExpr {
  predicate isSelfCall() { this.getQualifier() instanceof SelfRefExpr }

  predicate isSuperCall() { this.getQualifier() instanceof SuperRefExpr }
}
