import powershell

class ArrayExpr extends @array_expression, Expr {
  override SourceLocation getLocation() { array_expression_location(this, result) }

  StmtBlock getStmtBlock() { array_expression(this, result) }

  /**
   * Gets the i'th element of this `ArrayExpr`, if this can be determined statically.
   *
   * See `getStmtBlock` when the array elements are not known statically.
   */
  Expr getElement(int i) {
    result =
      unique( | | this.getStmtBlock().getAStmt()).(CmdExpr).getExpr().(ArrayLiteral).getElement(i)
  }

  /**
   * Gets an element of this `ArrayExpr`, if this can be determined statically.
   *
   * See `getStmtBlock` when the array elements are not known statically.
   */
  Expr getAnElement() { result = this.getElement(_) }

  override string toString() { result = "@(...)" }
}
