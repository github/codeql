private import codeql.swift.generated.expr.ExplicitCastExpr

class ExplicitCastExpr extends ExplicitCastExprBase {
  override predicate convertsFrom(Expr e) { e = getImmediateSubExpr() }

  override string toString() { result = "(" + this.getType() + ") ..." }
}
