private import codeql.swift.generated.expr.AssignExpr
private import codeql.swift.elements.expr.internal.BinaryExprImpl::Impl
private import codeql.swift.elements.expr.internal.ExprImpl::Impl as ExprImpl

module Impl {
  /**
   * An assignment expression. For example:
   * ```
   * x = 0
   * y += 1
   * z <<= 1
   * ```
   */
  abstract class Assignment extends ExprImpl::Expr {
    /**
     * Gets the destination of this assignment. For example `x` in:
     * ```
     * x = y
     * ```
     */
    abstract Expr getDest();

    /**
     * Gets the source of this assignment. For example `y` in:
     * ```
     * x = y
     * ```
     */
    abstract Expr getSource();

    /**
     * Holds if this assignment expression uses an overflow operator, that is,
     * an operator that truncates overflow rather than reporting an error.
     * ```
     * x &+= y
     * ```
     */
    predicate hasOverflowOperator() {
      this.(AssignOperation).getOperator().getName() =
        ["&*=(_:_:)", "&+=(_:_:)", "&-=(_:_:)", "&<<=(_:_:)", "&>>=(_:_:)"]
    }
  }

  /**
   * A simple assignment expression using the `=` operator:
   * ```
   * x = 0
   * ```
   */
  class AssignExpr extends Generated::AssignExpr {
    override string toString() { result = " ... = ..." }
  }

  private class AssignExprAssignment extends Assignment instanceof AssignExpr {
    override Expr getDest() { result = AssignExpr.super.getDest() }

    override Expr getSource() { result = AssignExpr.super.getSource() }
  }

  /**
   * An assignment expression apart from `=`. For example:
   * ```
   * x += 1
   * y &= z
   * ```
   */
  abstract class AssignOperation extends Assignment, BinaryExpr {
    override Expr getDest() { result = this.getLeftOperand() }

    override Expr getSource() { result = this.getRightOperand() }
  }

  /**
   * An arithmetic assignment expression. For example:
   * ```
   * x += 1
   * y *= z
   * ```
   */
  abstract class AssignArithmeticOperation extends AssignOperation { }

  /**
   * A bitwise assignment expression. For example:
   * ```
   * x &= y
   * z <<= 1
   * ```
   */
  abstract class AssignBitwiseOperation extends AssignOperation { }

  /**
   * A pointwise assignment expression. For example:
   * ```
   * x .&= y
   * ```
   */
  abstract class AssignPointwiseOperation extends AssignOperation { }

  /**
   * An addition assignment expression:
   * ```
   * a += b
   * a &+= b
   * ```
   */
  class AssignAddExpr extends AssignArithmeticOperation {
    AssignAddExpr() { this.getOperator().getName() = ["+=(_:_:)", "&+=(_:_:)"] }
  }

  /**
   * A subtraction assignment expression:
   * ```
   * a -= b
   * a &-= b
   * ```
   */
  class AssignSubExpr extends AssignArithmeticOperation {
    AssignSubExpr() { this.getOperator().getName() = ["-=(_:_:)", "&-=(_:_:)"] }
  }

  /**
   * A multiplication assignment expression:
   * ```
   * a *= b
   * a &*= b
   * ```
   */
  class AssignMulExpr extends AssignArithmeticOperation {
    AssignMulExpr() { this.getOperator().getName() = ["*=(_:_:)", "&*=(_:_:)"] }
  }

  /**
   * A division assignment expression:
   * ```
   * a /= b
   * ```
   */
  class AssignDivExpr extends AssignArithmeticOperation {
    AssignDivExpr() { this.getOperator().getName() = "/=(_:_:)" }
  }

  /**
   * A remainder assignment expression:
   * ```
   * a %= b
   * ```
   */
  class AssignRemExpr extends AssignArithmeticOperation {
    AssignRemExpr() { this.getOperator().getName() = "%=(_:_:)" }
  }

  /**
   * A left-shift assignment expression:
   * ```
   * a <<= b
   * a &<<= b
   * ```
   */
  class AssignLShiftExpr extends AssignBitwiseOperation {
    AssignLShiftExpr() { this.getOperator().getName() = ["<<=(_:_:)", "&<<=(_:_:)"] }
  }

  /**
   * A right-shift assignment expression:
   * ```
   * a >>= b
   * a &>>= b
   * ```
   */
  class AssignRShiftExpr extends AssignBitwiseOperation {
    AssignRShiftExpr() { this.getOperator().getName() = [">>=(_:_:)", "&>>=(_:_:)"] }
  }

  /**
   * A bitwise-and assignment expression:
   * ```
   * a &= b
   * ```
   */
  class AssignAndExpr extends AssignBitwiseOperation {
    AssignAndExpr() { this.getOperator().getName() = "&=(_:_:)" }
  }

  /**
   * A bitwise-or assignment expression:
   * ```
   * a |= b
   * ```
   */
  class AssignOrExpr extends AssignBitwiseOperation {
    AssignOrExpr() { this.getOperator().getName() = "|=(_:_:)" }
  }

  /**
   * A bitwise exclusive-or assignment expression:
   * ```
   * a ^= b
   * ```
   */
  class AssignXorExpr extends AssignBitwiseOperation {
    AssignXorExpr() { this.getOperator().getName() = "^=(_:_:)" }
  }

  /**
   * A pointwise bitwise-and assignment expression:
   * ```
   * a .&= b
   * ```
   */
  class AssignPointwiseAndExpr extends AssignPointwiseOperation {
    AssignPointwiseAndExpr() { this.getOperator().getName() = ".&=(_:_:)" }
  }

  /**
   * A pointwise bitwise-or assignment expression:
   * ```
   * a .|= b
   * ```
   */
  class AssignPointwiseOrExpr extends AssignPointwiseOperation {
    AssignPointwiseOrExpr() { this.getOperator().getName() = ".|=(_:_:)" }
  }

  /**
   * A pointwise bitwise exclusive-or assignment expression:
   * ```
   * a .^= b
   * ```
   */
  class AssignPointwiseXorExpr extends AssignPointwiseOperation {
    AssignPointwiseXorExpr() { this.getOperator().getName() = ".^=(_:_:)" }
  }
}
