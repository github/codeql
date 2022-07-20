private import codeql.swift.generated.expr.ImplicitConversionExpr

class ImplicitConversionExpr extends ImplicitConversionExprBase {
  override predicate convertsFrom(Expr e) { e = getImmediateSubExpr() }

  override string toString() { result = "(" + this.getType().toString() + ") ..." }
}
