private import codeql.swift.generated.expr.AssignExpr
private import codeql.swift.elements.expr.BinaryExpr

/**
 * An assignment expression. For example:
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
    this instanceof AssignBitwiseOperationEx or
    this instanceof AssignPointwiseOperationEx
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

/**
 * An assignment expression apart from `=`. For example:
 * ```
 * x += 1
 * y &= z
 * ```
 */
class AssignOperation extends Assignment, BinaryExpr {
  AssignOperation() {
    this instanceof AssignArithmeticOperationEx or
    this instanceof AssignBitwiseOperationEx or
    this instanceof AssignPointwiseOperationEx
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
 * A pointwise assignment expression. For example:
 * ```
 * x .&= y
 * ```
 */
class AssignPointwiseOperation extends AssignOperation instanceof AssignPointwiseOperationEx { }

/**
 * Private abstract class, extended to define the scope of `AssignPointwiseOperation`.
 */
abstract private class AssignPointwiseOperationEx extends BinaryExpr { }

/**
 * An addition assignment expression:
 * ```
 * a += b
 * a &+= b
 * ```
 */
class AssignAddExpr extends AssignArithmeticOperationEx {
  AssignAddExpr() { this.getOperator().getName() = ["+=(_:_:)", "&+=(_:_:)"] }
}

/**
 * A subtraction assignment expression:
 * ```
 * a -= b
 * a &-= b
 * ```
 */
class AssignSubExpr extends AssignArithmeticOperationEx {
  AssignSubExpr() { this.getOperator().getName() = ["-=(_:_:)", "&-=(_:_:)"] }
}

/**
 * A multiplication assignment expression:
 * ```
 * a *= b
 * a &*= b
 * ```
 */
class AssignMulExpr extends AssignArithmeticOperationEx {
  AssignMulExpr() { this.getOperator().getName() = ["*=(_:_:)", "&*=(_:_:)"] }
}

/**
 * A division assignment expression:
 * ```
 * a /= b
 * ```
 */
class AssignDivExpr extends AssignArithmeticOperationEx {
  AssignDivExpr() { this.getOperator().getName() = "/=(_:_:)" }
}

/**
 * A remainder assignment expression:
 * ```
 * a %= b
 * ```
 */
class AssignRemExpr extends AssignArithmeticOperationEx {
  AssignRemExpr() { this.getOperator().getName() = "%=(_:_:)" }
}

/**
 * A left-shift assignment expression:
 * ```
 * a <<= b
 * a &<<= b
 * ```
 */
class AssignLShiftExpr extends AssignBitwiseOperationEx {
  AssignLShiftExpr() { this.getOperator().getName() = ["<<=(_:_:)", "&<<=(_:_:)"] }
}

/**
 * A right-shift assignment expression:
 * ```
 * a >>= b
 * a &>>= b
 * ```
 */
class AssignRShiftExpr extends AssignBitwiseOperationEx {
  AssignRShiftExpr() { this.getOperator().getName() = [">>=(_:_:)", "&>>=(_:_:)"] }
}

/**
 * A bitwise-and assignment expression:
 * ```
 * a &= b
 * ```
 */
class AssignAndExpr extends AssignBitwiseOperationEx {
  AssignAndExpr() { this.getOperator().getName() = "&=(_:_:)" }
}

/**
 * A bitwise-or assignment expression:
 * ```
 * a |= b
 * ```
 */
class AssignOrExpr extends AssignBitwiseOperationEx {
  AssignOrExpr() { this.getOperator().getName() = "|=(_:_:)" }
}

/**
 * A bitwise exclusive-or assignment expression:
 * ```
 * a ^= b
 * ```
 */
class AssignXorExpr extends AssignBitwiseOperationEx {
  AssignXorExpr() { this.getOperator().getName() = "^=(_:_:)" }
}

/**
 * A pointwise bitwise-and assignment expression:
 * ```
 * a .&= b
 * ```
 */
class AssignPointwiseAndExpr extends AssignPointwiseOperationEx {
  AssignPointwiseAndExpr() { this.getOperator().getName() = ".&=(_:_:)" }
}

/**
 * A pointwise bitwise-or assignment expression:
 * ```
 * a .|= b
 * ```
 */
class AssignPointwiseOrExpr extends AssignPointwiseOperationEx {
  AssignPointwiseOrExpr() { this.getOperator().getName() = ".|=(_:_:)" }
}

/**
 * A pointwise bitwise exclusive-or assignment expression:
 * ```
 * a .^= b
 * ```
 */
class AssignPointwiseXorExpr extends AssignPointwiseOperationEx {
  AssignPointwiseXorExpr() { this.getOperator().getName() = ".^=(_:_:)" }
}
