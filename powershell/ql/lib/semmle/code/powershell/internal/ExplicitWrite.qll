private import powershell

module Private {
  /**
   * Holds if `e` is written to by `assign`.
   *
   * Note there may be more than one `e` for which `isExplicitWrite(e, assign)`
   * holds if the left-hand side is an array literal.
   */
  predicate isExplicitWrite(Expr e, AssignStmt assign) {
    e = assign.getLeftHandSide()
    or
    e = any(ConvertExpr convert | isExplicitWrite(convert, assign)).getBase()
    or
    e = any(ArrayLiteral array | isExplicitWrite(array, assign)).getAnElement()
  }
}

module Public { }
