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
class BinaryArithmeticOperation extends BinaryExpr {
  BinaryArithmeticOperation() {
    this instanceof AddExpr or
    this instanceof SubExpr or
    this instanceof MulExpr or
    this instanceof DivExpr or
    this instanceof RemExpr
  }
}

/**
 * An add expression.
 * ```
 * a + b
 * ```
 */
class AddExpr extends BinaryExpr {
  AddExpr() { this.getStaticTarget().getName() = "+(_:_:)" }
}

/**
 * A subtract expression.
 * ```
 * a - b
 * ```
 */
class SubExpr extends BinaryExpr {
  SubExpr() { this.getStaticTarget().getName() = "-(_:_:)" }
}

/**
 * A multiply expression.
 * ```
 * a * b
 * ```
 */
class MulExpr extends BinaryExpr {
  MulExpr() { this.getStaticTarget().getName() = "*(_:_:)" }
}

/**
 * A divide expression.
 * ```
 * a / b
 * ```
 */
class DivExpr extends BinaryExpr {
  DivExpr() { this.getStaticTarget().getName() = "/(_:_:)" }
}

/**
 * A remainder expression.
 * ```
 * a % b
 * ```
 */
class RemExpr extends BinaryExpr {
  RemExpr() { this.getStaticTarget().getName() = "%(_:_:)" }
}

/**
 * A unary arithmetic operation, such as:
 * ```
 * -a
 * ```
 */
class UnaryArithmeticOperation extends PrefixUnaryExpr instanceof UnaryMinusExpr { }

/**
 * A unary minus expression.
 * ```
 * -a
 * ```
 */
class UnaryMinusExpr extends PrefixUnaryExpr {
  UnaryMinusExpr() { this.getStaticTarget().getName() = "-(_:)" }
}
