import java

/** A subclass of `PrimitiveType` with width-based ordering methods. */
class OrdPrimitiveType extends PrimitiveType {
  predicate widerThan(OrdPrimitiveType that) { this.getWidthRank() > that.getWidthRank() }

  predicate widerThanOrEqualTo(OrdPrimitiveType that) { this.getWidthRank() >= that.getWidthRank() }

  OrdPrimitiveType maxType(OrdPrimitiveType that) {
    this.widerThan(that) and result = this
    or
    not this.widerThan(that) and result = that
  }

  int getWidthRank() {
    this.getName() = "byte" and result = 1
    or
    this.getName() = "short" and result = 2
    or
    this.getName() = "int" and result = 3
    or
    this.getName() = "long" and result = 4
    or
    this.getName() = "float" and result = 5
    or
    this.getName() = "double" and result = 6
  }

  float getMaxValue() {
    this.getName() = "byte" and result = 127.0
    or
    this.getName() = "short" and result = 32767.0
    or
    this.getName() = "int" and result = 2147483647.0
    or
    // Long.MAX_VALUE is 9223372036854775807 but floating point only has 53 bits of precision.
    this.getName() = "long" and result = 9223372036854776000.0
    // don't try for floats and doubles
  }

  float getMinValue() {
    this.getName() = "byte" and result = -128.0
    or
    this.getName() = "short" and result = -32768.0
    or
    this.getName() = "int" and result = -2147483648.0
    or
    // Long.MIN_VALUE is -9223372036854775808 but floating point only has 53 bits of precision.
    this.getName() = "long" and result = -9223372036854776000.0
    // don't try for floats and doubles
  }
}

class NumType extends Type {
  NumType() {
    this instanceof PrimitiveType or
    this instanceof BoxedType
  }

  /** Gets the width-ordered primitive type corresponding to this type. */
  OrdPrimitiveType getOrdPrimitiveType() {
    this instanceof PrimitiveType and result = this
    or
    this instanceof BoxedType and result = this.(BoxedType).getPrimitiveType()
  }

  predicate widerThan(NumType that) {
    this.getOrdPrimitiveType().widerThan(that.getOrdPrimitiveType())
  }

  predicate widerThanOrEqualTo(NumType that) {
    this.getOrdPrimitiveType().widerThanOrEqualTo(that.getOrdPrimitiveType())
  }

  int getWidthRank() { result = this.getOrdPrimitiveType().getWidthRank() }
}

class ArithExpr extends Expr {
  ArithExpr() {
    (
      this instanceof UnaryAssignExpr or
      this instanceof AddExpr or
      this instanceof MulExpr or
      this instanceof SubExpr or
      this instanceof DivExpr
    ) and
    forall(Expr e | e = this.(BinaryExpr).getAnOperand() or e = this.(UnaryAssignExpr).getExpr() |
      e.getType() instanceof NumType
    )
  }

  OrdPrimitiveType getOrdPrimitiveType() {
    exists(OrdPrimitiveType t1, OrdPrimitiveType t2 |
      t1 = this.getLeftOperand().getType().(NumType).getOrdPrimitiveType() and
      t2 = this.getRightOperand().getType().(NumType).getOrdPrimitiveType() and
      result = t1.maxType(t2)
    )
  }

  /**
   * Gets the left-hand operand of a binary expression
   * or the operand of a unary assignment expression.
   */
  Expr getLeftOperand() {
    result = this.(BinaryExpr).getLeftOperand() or
    result = this.(UnaryAssignExpr).getExpr()
  }

  /**
   * Gets the right-hand operand if this is a binary expression.
   */
  Expr getRightOperand() { result = this.(BinaryExpr).getRightOperand() }

  /** Gets an operand of this arithmetic expression. */
  Expr getAnOperand() {
    result = this.(BinaryExpr).getAnOperand() or
    result = this.(UnaryAssignExpr).getExpr()
  }
}
