private import codeql.swift.generated.expr.ImplicitConversionExpr

class ImplicitConversionExpr extends Generated::ImplicitConversionExpr {
  override predicate convertsFrom(Expr e) { e = this.getImmediateSubExpr() }

  override string toString() { result = "(" + this.getType().toString() + ") ..." }
}
