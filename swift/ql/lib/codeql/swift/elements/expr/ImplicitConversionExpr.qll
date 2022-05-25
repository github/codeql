private import codeql.swift.generated.expr.ImplicitConversionExpr

class ImplicitConversionExpr extends ImplicitConversionExprBase {
  override predicate convertsFrom(Expr e) { implicit_conversion_exprs(this, e) }
}
