private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.BinaryExpr
private import codeql.swift.elements.expr.PrefixUnaryExpr
private import codeql.swift.elements.expr.DotSyntaxCallExpr

/**
 * An arithmetic operation, such as:
 * ```
 * a + b
 * ```
 */
class ArithmeticOperation extends Expr {
  ArithmeticOperation() {
    this instanceof BinaryArithmeticOperation or
    this instanceof UnaryArithmeticOperation
  }

  /**
   * Gets an operand of this arithmetic operation.
   */
  Expr getAnOperand() {
    result = this.(BinaryArithmeticOperation).getAnOperand()
    or
    result = this.(UnaryArithmeticOperation).getOperand()
  }
}

/**
 * A binary arithmetic operation, such as:
 * ```
 * a + b
 * ```
 */
abstract class BinaryArithmeticOperation extends BinaryExpr { }

/**
 * An add expression.
 * ```
 * a + b
 * ```
 */
class AddExpr extends BinaryArithmeticOperation {
  AddExpr() { this.getFunction().(DotSyntaxCallExpr).getStaticTarget().getName() = "+(_:_:)" }
}

/**
 * A subtract expression.
 * ```
 * a - b
 * ```
 */
class SubExpr extends BinaryArithmeticOperation {
  SubExpr() { this.getFunction().(DotSyntaxCallExpr).getStaticTarget().getName() = "-(_:_:)" }
}

/**
 * A multiply expression.
 * ```
 * a * b
 * ```
 */
class MulExpr extends BinaryArithmeticOperation {
  MulExpr() { this.getFunction().(DotSyntaxCallExpr).getStaticTarget().getName() = "*(_:_:)" }
}

/**
 * A divide expression.
 * ```
 * a / b
 * ```
 */
class DivExpr extends BinaryArithmeticOperation {
  DivExpr() { this.getFunction().(DotSyntaxCallExpr).getStaticTarget().getName() = "/(_:_:)" }
}

/**
 * A remainder expression.
 * ```
 * a % b
 * ```
 */
class RemExpr extends BinaryArithmeticOperation {
  RemExpr() { this.getFunction().(DotSyntaxCallExpr).getStaticTarget().getName() = "%(_:_:)" }
}

/**
 * A unary arithmetic operation, such as:
 * ```
 * -a
 * ```
 */
abstract class UnaryArithmeticOperation extends PrefixUnaryExpr { }

/**
 * A unary minus expression.
 * ```
 * -a
 * ```
 */
class UnaryMinusExpr extends UnaryArithmeticOperation {
  UnaryMinusExpr() { this.getFunction().(DotSyntaxCallExpr).getStaticTarget().getName() = "-(_:)" }
}
