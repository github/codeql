private import codeql.swift.generated.expr.BinaryExpr
private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.decl.Function

module Impl {
  /**
   * A Swift binary expression, that is, an expression that appears between its
   * two operands. For example:
   * ```
   * x + y
   * ```
   */
  class BinaryExpr extends Generated::BinaryExpr {
    /**
     * Gets the left operand (left expression) of this binary expression.
     */
    Expr getLeftOperand() { result = this.getArgument(0).getExpr() }

    /**
     * Gets the right operand (right expression) of this binary expression.
     */
    Expr getRightOperand() { result = this.getArgument(1).getExpr() }

    /**
     * Gets the operator of this binary expression (the function that is called).
     */
    Function getOperator() { result = this.getStaticTarget() }

    /**
     * Gets an operand of this binary expression (left or right).
     */
    Expr getAnOperand() { result = [this.getLeftOperand(), this.getRightOperand()] }

    override string toString() { result = "... " + this.getFunction().toString() + " ..." }

    override Function getStaticTarget() { result = super.getStaticTarget() }
  }
}
