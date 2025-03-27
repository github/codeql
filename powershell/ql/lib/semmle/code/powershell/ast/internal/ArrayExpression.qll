private import AstImport

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
