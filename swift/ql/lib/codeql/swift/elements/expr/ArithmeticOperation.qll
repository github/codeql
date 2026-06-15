private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.BinaryExpr
private import codeql.swift.elements.expr.PrefixUnaryExpr
private import codeql.swift.elements.expr.internal.DotSyntaxCallExpr

/**
 * An arithmetic operation, such as:
 * ```
 * a + b
 * ```
 */
final class ArithmeticOperation extends Expr {
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
final class BinaryArithmeticOperation extends BinaryExpr {
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
 * a &+ b
 * ```
 */
final class AddExpr extends BinaryExpr {
  AddExpr() { this.getStaticTarget().getName() = ["+(_:_:)", "&+(_:_:)"] }
}

/**
 * A subtract expression.
 * ```
 * a - b
 * a &- b
 * ```
 */
final class SubExpr extends BinaryExpr {
  SubExpr() { this.getStaticTarget().getName() = ["-(_:_:)", "&-(_:_:)"] }
}

/**
 * A multiply expression.
 * ```
 * a * b
 * a &* b
 * ```
 */
final class MulExpr extends BinaryExpr {
  MulExpr() { this.getStaticTarget().getName() = ["*(_:_:)", "&*(_:_:)"] }
}

/**
 * A divide expression.
 * ```
 * a / b
 * ```
 */
final class DivExpr extends BinaryExpr {
  DivExpr() { this.getStaticTarget().getName() = "/(_:_:)" }
}

/**
 * A remainder expression.
 * ```
 * a % b
 * ```
 */
final class RemExpr extends BinaryExpr {
  RemExpr() { this.getStaticTarget().getName() = "%(_:_:)" }
}

/**
 * A unary arithmetic operation, such as:
 * ```
 * -a
 * ```
 */
final class UnaryArithmeticOperation extends PrefixUnaryExpr {
  UnaryArithmeticOperation() {
    this instanceof UnaryMinusExpr or
    this instanceof UnaryPlusExpr
  }
}

/**
 * A unary minus expression.
 * ```
 * -a
 * ```
 */
final class UnaryMinusExpr extends PrefixUnaryExpr {
  UnaryMinusExpr() { this.getStaticTarget().getName() = "-(_:)" }
}

/**
 * A unary plus expression.
 * ```
 * +a
 * ```
 */
final class UnaryPlusExpr extends PrefixUnaryExpr {
  UnaryPlusExpr() { this.getStaticTarget().getName() = "+(_:)" }
}
