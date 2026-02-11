private import codeql.swift.generated.expr.PostfixUnaryExpr
private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.decl.Function

module Impl {
  /**
   * A Swift postfix unary expression, that is, a unary expression that appears
   * after its operand. For example:
   * ```
   * x!
   * ```
   */
  class PostfixUnaryExpr extends Generated::PostfixUnaryExpr {
    /**
     *  Gets the operand (expression) of this postfix unary expression.
     */
    Expr getOperand() { result = this.getAnArgument().getExpr() }

    /**
     * Gets the operator of this postfix unary expression (the function that is called).
     */
    Function getOperator() { result = this.getStaticTarget() }
  }
}
