/**
 * @name Possible loss of precision
 * @description Dividing or multiplying integral expressions and converting the result to a
 *              floating-point value may result in a loss of precision.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/loss-of-precision
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-190
 *       external/cwe/cwe-192
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import csharp

/** Holds if `e` is converted to type `t` which is a `float` or a `decimal`. */
predicate convertedToFloatOrDecimal(Expr e, Type t) {
  exists(CastExpr cast |
    cast.getExpr() = e and
    t = cast.getType()
  |
    t instanceof FloatingPointType or
    t instanceof DecimalType
  )
  or
  exists(BinaryArithmeticOperation op |
    op.getAnOperand() = e and
    convertedToFloatOrDecimal(op, t)
  |
    op instanceof AddExpr or
    op instanceof SubExpr or
    op instanceof MulExpr
  )
}

/** Holds if `div` is an exact integer division. */
predicate exactDivision(DivExpr div) {
  exists(int numerator, int denominator |
    numerator = div.getNumerator().stripCasts().getValue().toInt() and
    denominator = div.getDenominator().stripCasts().getValue().toInt() and
    numerator % denominator = 0
  )
}

/** An expression that may result in a loss of precision. */
abstract class LossOfPrecision extends Expr {
  Type convertedType;

  LossOfPrecision() {
    this.getType() instanceof IntegralType and
    convertedToFloatOrDecimal(this, convertedType)
  }

  /** Gets the alert message. */
  abstract string getMessage();
}

/** A division expression that may result in a loss of precision. */
class DivLossOfPrecision extends LossOfPrecision, DivExpr {
  DivLossOfPrecision() { not exactDivision(this) }

  override string getMessage() { result = "Possible loss of precision: any fraction will be lost." }
}

/** Holds if `e` is a constant multiplication that does not overflow. */
predicate small(MulExpr e) {
  exists(float lhs, float rhs, float res, IntegralType t |
    lhs = e.getLeftOperand().stripCasts().getValue().toFloat() and
    rhs = e.getRightOperand().stripCasts().getValue().toFloat() and
    lhs * rhs = res and
    t = e.getType() and
    not res < t.minValue() and
    not res > t.maxValue()
  )
}

/** A multiplication expression that may result in a loss of precision. */
class MulLossOfPrecision extends LossOfPrecision, MulExpr {
  MulLossOfPrecision() { not small(this) }

  override string getMessage() {
    result =
      "Possible overflow: result of integer multiplication cast to " +
        convertedType.toStringWithTypes() + "."
  }
}

from LossOfPrecision e
select e, e.getMessage()
