private import codeql.swift.generated.expr.OneWayExpr

class OneWayExpr extends OneWayExprBase {
  override predicate convertsFrom(Expr e) { one_way_exprs(this, e) }

  override string toString() { result = this.getSubExpr().toString() }
}
