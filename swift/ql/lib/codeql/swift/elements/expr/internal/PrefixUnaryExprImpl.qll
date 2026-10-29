private import codeql.swift.generated.expr.PrefixUnaryExpr
private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.decl.Function

module Impl {
  /**
   * A Swift prefix unary expression, that is, a unary expression that appears
   * before its operand. For example:
   * ```
   * -x
   * ```
   */
  class PrefixUnaryExpr extends Generated::PrefixUnaryExpr {
    /**
     *  Gets the operand (expression) of this prefix unary expression.
     */
    Expr getOperand() { result = this.getAnArgument().getExpr() }

    /**
     * Gets the operator of this prefix unary expression (the function that is called).
     */
    Function getOperator() { result = this.getStaticTarget() }

    override Function getStaticTarget() { result = super.getStaticTarget() }
  }
}
