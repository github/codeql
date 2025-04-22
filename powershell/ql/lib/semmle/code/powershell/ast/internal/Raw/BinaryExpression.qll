private import Raw

class BinaryExpr extends @binary_expression, Expr {
  override SourceLocation getLocation() { binary_expression_location(this, result) }

  int getKind() { binary_expression(this, result, _, _) }

  /** Gets an operand of this binary expression. */
  Expr getAnOperand() {
    result = this.getLeft()
    or
    result = this.getRight()
  }

  final override Ast getChild(ChildIndex i) {
    i = BinaryExprLeft() and
    result = this.getLeft()
    or
    i = BinaryExprRight() and
    result = this.getRight()
  }

  /** Holds if this binary expression has the operands `e1` and `e2`. */
  predicate hasOperands(Expr e1, Expr e2) {
    e1 = this.getLeft() and
    e2 = this.getRight()
    or
    e1 = this.getRight() and
    e2 = this.getLeft()
  }

  Expr getLeft() { binary_expression(this, _, result, _) }

  Expr getRight() { binary_expression(this, _, _, result) }
}
