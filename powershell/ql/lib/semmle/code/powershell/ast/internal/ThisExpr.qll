private import AstImport

/**
 * A this expression. For example:
 * ```
 * $this.PropertyName
 * $this.Method()
 * ```
 */
class ThisExpr extends Expr, TThisExpr {
  final override string toString() { result = "this" }

}
