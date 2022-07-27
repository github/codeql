private import codeql.swift.generated.expr.ExplicitCastExpr

class ExplicitCastExpr extends ExplicitCastExprBase {
  override predicate convertsFrom(Expr e) { e = this.getImmediateSubExpr() }

  override string toString() { result = "(" + this.getType() + ") ..." }
}
