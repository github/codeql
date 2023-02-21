private import codeql.swift.generated.expr.AssignExpr
private import codeql.swift.elements.expr.BinaryExpr

/**
 * Any assignment expression. For example:
 * ```
 * x = 0
 * y += 1
 * z <<= 1
 * ```
 */
class Assignment extends Expr {
  Assignment() {
    this instanceof AssignExpr or
    this instanceof AssignArithmeticOperationEx or
    this instanceof AssignBitwiseOperationEx
  }

  /**
   * Gets the destination of this assignment. For example `x` in:
   * ```
   * x = y
   * ```
   */
  Expr getDest() {
    result = this.(AssignExpr).getDest() or
    result = this.(AssignOperation).getLeftOperand()
  }

  /**
   * Gets the source of this assignment. For example `y` in:
   * ```
   * x = y
   * ```
   */
  Expr getSource() {
    result = this.(AssignExpr).getSource() or
    result = this.(AssignOperation).getRightOperand()
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

/**
 * Any assignment expression apart from `=`. For example:
 * ```
 * x += 1
 * y &= z
 * ```
 */
class AssignOperation extends Assignment, BinaryExpr {
  AssignOperation() {
    this instanceof AssignArithmeticOperationEx or
    this instanceof AssignBitwiseOperationEx
  }
}

/**
 * An arithmetic assignment expression. For example:
 * ```
 * x += 1
 * y *= z
 * ```
 */
class AssignArithmeticOperation extends AssignOperation instanceof AssignArithmeticOperationEx { }

/**
 * Private abstract class, extended to define the scope of `AssignArithmeticOperation`.
 */
abstract private class AssignArithmeticOperationEx extends BinaryExpr { }

/**
 * A bitwise assignment expression. For example:
 * ```
 * x &= y
 * z <<= 1
 * ```
 */
class AssignBitwiseOperation extends AssignOperation instanceof AssignBitwiseOperationEx { }

/**
 * Private abstract class, extended to define the scope of `AssignBitwiseOperation`.
 */
abstract private class AssignBitwiseOperationEx extends BinaryExpr { }

/**
 * An addition assignment expression:
 * ```
 * a += b
 * ```
 */
class AssignAddExpr extends AssignArithmeticOperationEx {
  AssignAddExpr() { this.getOperator().getName() = "+=(_:_:)" }

  override string toString() { result = "... += ..." }
}

/**
 * A left-shift assignment expression:
 * ```
 * a <<= b
 * ```
 */
class AssignLShiftExpr extends AssignBitwiseOperationEx {
  AssignLShiftExpr() { this.getOperator().getName() = "<<=(_:_:)" }

  override string toString() { result = "... <<= ..." }
}
// TODO ...
