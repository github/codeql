private import codeql.swift.generated.expr.OneWayExpr

class OneWayExpr extends OneWayExprBase {
  override predicate convertsFrom(Expr e) { e = getImmediateSubExpr() }

  override string toString() { result = this.getSubExpr().toString() }
}
