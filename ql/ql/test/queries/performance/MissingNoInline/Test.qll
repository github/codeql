import ql

/**
 * Holds if `add.getLeftOperand() = e1` and `add.getRightOperand() = e2`.
 *
 * This predicate exists to fix a join order.
 */
predicate missingNoInline(AddExpr add, Expr e1, Expr e2) {
  // BAD
  add.getLeftOperand() = e1 and
  add.getRightOperand() = e2
}

/**
 * Holds if `add.getLeftOperand() = e1` and `add.getRightOperand() = e2`.
 *
 * This predicate exists to fix a join order.
 */
pragma[noinline]
predicate noInlined(AddExpr add, Expr e1, Expr e2) {
  // GOOD
  add.getLeftOperand() = e1 and
  add.getRightOperand() = e2
}

/**
 * Holds if `add.getLeftOperand() = e1` and `add.getRightOperand() = e2`.
 *
 * This predicate exists to fix a join order.
 */
pragma[nomagic]
predicate nomagicd(AddExpr add, Expr e1, Expr e2) {
  // GOOD
  add.getLeftOperand() = e1 and
  add.getRightOperand() = e2
}

/**
 * Holds if `add.getLeftOperand() = e1` and `add.getRightOperand() = e2`.
 *
 * This predicate exists to fix a join order.
 */
pragma[inline]
predicate inlined(AddExpr add, Expr e1, Expr e2) {
  // GOOD
  add.getLeftOperand() = e1 and
  add.getRightOperand() = e2
}

/**
 * Holds if `add.getLeftOperand() = e1` and `add.getRightOperand() = e2`.
 *
 * This predicate exists to fix a join order.
 */
bindingset[add]
predicate hasBindingset(AddExpr add, Expr e1, Expr e2) {
  // GOOD
  add.getLeftOperand() = e1 and
  add.getRightOperand() = e2
}

/**
 * Holds if `add.getLeftOperand() = e1` and `add.getRightOperand() = e2`.
 *
 * This predicate exists to fix a join order.
 */
pragma[noopt]
predicate noOpted(AddExpr add, Expr e1, Expr e2) {
  // GOOD
  add instanceof AddExpr and
  add.getLeftOperand() = e1 and
  add.getRightOperand() = e2
}
