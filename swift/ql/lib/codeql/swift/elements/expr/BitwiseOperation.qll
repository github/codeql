private import codeql.swift.elements.expr.BinaryExpr
private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.PrefixUnaryExpr

/**
 * A bitwise operation, such as:
 * ```
 * a & b
 * a << b
 * ~a
 * ```
 */
class BitwiseOperation extends Expr {
  BitwiseOperation() {
    this instanceof BinaryBitwiseOperation or
    this instanceof UnaryBitwiseOperation
  }

  /**
   * Gets an operand of this bitwise operation.
   */
  Expr getAnOperand() {
    result =
      [this.(BinaryBitwiseOperation).getAnOperand(), this.(UnaryBitwiseOperation).getOperand()]
  }
}

/**
 * A binary bitwise operation, such as:
 * ```
 * a & b
 * a << b
 * a .^ b
 * ```
 */
class BinaryBitwiseOperation extends BinaryExpr {
  BinaryBitwiseOperation() {
    this instanceof AndBitwiseExpr or
    this instanceof OrBitwiseExpr or
    this instanceof XorBitwiseExpr or
    this instanceof PointwiseAndExpr or
    this instanceof PointwiseOrExpr or
    this instanceof PointwiseXorExpr or
    this instanceof ShiftLeftBitwiseExpr or
    this instanceof ShiftRightBitwiseExpr
  }
}

/**
 * A bitwise AND expression.
 * ```
 * a & b
 * ```
 */
class AndBitwiseExpr extends BinaryExpr {
  AndBitwiseExpr() { this.getStaticTarget().getName() = "&(_:_:)" }
}

/**
 * A bitwise OR expression.
 * ```
 * a | b
 * ```
 */
class OrBitwiseExpr extends BinaryExpr {
  OrBitwiseExpr() { this.getStaticTarget().getName() = "|(_:_:)" }
}

/**
 * A bitwise XOR expression.
 * ```
 * a ^ b
 * ```
 */
class XorBitwiseExpr extends BinaryExpr {
  XorBitwiseExpr() { this.getStaticTarget().getName() = "^(_:_:)" }
}

/**
 * A pointwise bitwise-and expression:
 * ```
 * a .& b
 * ```
 */
class PointwiseAndExpr extends BinaryExpr {
  PointwiseAndExpr() { this.getOperator().getName() = ".&(_:_:)" }
}

/**
 * A pointwise bitwise-or expression:
 * ```
 * a .| b
 * ```
 */
class PointwiseOrExpr extends BinaryExpr {
  PointwiseOrExpr() { this.getOperator().getName() = ".|(_:_:)" }
}

/**
 * A pointwise bitwise exclusive-or expression:
 * ```
 * a .^ b
 * ```
 */
class PointwiseXorExpr extends BinaryExpr {
  PointwiseXorExpr() { this.getOperator().getName() = ".^(_:_:)" }
}

/**
 * A bitwise shift left expression.
 * ```
 * a << b
 * a &<<
 * ```
 */
class ShiftLeftBitwiseExpr extends BinaryExpr {
  ShiftLeftBitwiseExpr() { this.getStaticTarget().getName() = ["<<(_:_:)", "&<<(_:_:)"] }
}

/**
 * A bitwise shift right expression.
 * ```
 * a >> b
 * a &>>
 * ```
 */
class ShiftRightBitwiseExpr extends BinaryExpr {
  ShiftRightBitwiseExpr() { this.getStaticTarget().getName() = [">>(_:_:)", "&>>(_:_:)"] }
}

/**
 * A unary bitwise operation, such as:
 * ```
 * ~a
 * ```
 */
class UnaryBitwiseOperation extends PrefixUnaryExpr instanceof NotBitwiseExpr { }

/**
 * A bitwise NOT expression.
 * ```
 * ~a
 * ```
 */
class NotBitwiseExpr extends PrefixUnaryExpr {
  NotBitwiseExpr() { this.getStaticTarget().getName() = "~(_:)" }
}
