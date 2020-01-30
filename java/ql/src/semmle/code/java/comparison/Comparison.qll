import java

/**
 * If `e1` evaluates to `b1` then the direct subexpression `e2` evaluates to `b2`.
 *
 * Used as basis for the transitive closure in `exprImplies`.
 */
private predicate exprImpliesStep(Expr e1, boolean b1, Expr e2, boolean b2) {
  e1.(LogNotExpr).getExpr() = e2 and
  b2 = b1.booleanNot() and
  (b1 = true or b1 = false)
  or
  b1 = true and e1.(AndLogicalExpr).getAnOperand() = e2 and b2 = true
  or
  b1 = false and e1.(OrLogicalExpr).getAnOperand() = e2 and b2 = false
}

/** If `e1` evaluates to `b1` then the subexpression `e2` evaluates to `b2`. */
predicate exprImplies(Expr e1, boolean b1, Expr e2, boolean b2) {
  e1 = e2 and
  b1 = b2 and
  (b1 = true or b1 = false)
  or
  exists(Expr emid, boolean bmid |
    exprImplies(e1, b1, emid, bmid) and exprImpliesStep(emid, bmid, e2, b2)
  )
}
