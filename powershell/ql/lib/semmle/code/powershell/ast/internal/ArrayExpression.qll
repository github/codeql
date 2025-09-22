private import AstImport

/**
 * An array expression. For example:
 * ```
 * $myArray = @("text", 42, $true)
 * ```
 * 
 * An array expression is an expression of the form `@(...)` where `...` is
 * a `StmtBlock` that computes the elements of the array. Often, that
 * `StmtBlock` is an `ArrayLiteral`, but that is not necessarily the case. For
 * example in:
 * ```
 * $squares = @(foreach ($n in 1..5) { $n * $n })
 * ```
 */
class ArrayExpr extends Expr, TArrayExpr {
  StmtBlock getStmtBlock() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, arrayExprStmtBlock(), result)
      or
      not synthChild(r, arrayExprStmtBlock(), result) and
      result = getResultAst(r.(Raw::ArrayExpr).getStmtBlock())
    )
  }

  override string toString() { result = "@(...)" }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = arrayExprStmtBlock() and result = this.getStmtBlock()
  }

  /**
   * Gets the i'th element of this `ArrayExpr`, if this can be determined statically.
   *
   * See `getStmtBlock` when the array elements are not known statically.
   */
  Expr getExpr(int i) {
    result =
      unique( | | this.getStmtBlock().getAStmt()).(ExprStmt).getExpr().(ArrayLiteral).getExpr(i)
  }

  /**
   * Gets an element of this `ArrayExpr`, if this can be determined statically.
   *
   * See `getStmtBlock` when the array elements are not known statically.
   */
  Expr getAnExpr() { result = this.getExpr(_) }
}
