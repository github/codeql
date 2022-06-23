private import codeql.swift.generated.expr.ExplicitCastExpr

class ExplicitCastExpr extends ExplicitCastExprBase {
  override predicate convertsFrom(Expr e) { explicit_cast_exprs(this, e) }

  override string toString() { result = "(" + this.getType() + ") ..." }
}
