/**
 * @name AV Rule 180
 * @description Implicit conversions that may result in a loss of information
 *              shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-180
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

import cpp

class IntConstantExpr extends Expr {
  IntConstantExpr() {
    this.getType() instanceof IntegralType and
    exists(this.getValue())
  }

  int getIntValue() { result = this.getValue().toInt() }

  predicate isNegative() { this.getIntValue() < 0 }

  /**
   * Find out how many (8, 16, 32, 64) bits are required.
   *      FIXME Currently only works up to 32 bits
   */
  int getRequiredSizeBits() {
    exists(int value |
      value = this.getIntValue() and
      (
        value < -32768 and result = 32
        or
        value >= -32768 and value < -128 and result = 16
        or
        value >= -128 and value < 0 and result = 8
        or
        value >= 0 and value < 128 and result = 7
        or
        value >= 128 and value < 256 and result = 8
        or
        value >= 256 and value < 32768 and result = 15
        or
        value >= 32768 and value < 65536 and result = 16
        or
        value >= 65536 and value <= 2147483647 and result = 31
        or
        value > 2147483647 and result = 32
      )
    )
  }
}

class ImplicitConversion extends Expr {
  ImplicitConversion() { super.hasImplicitConversion() }

  Type getUnderlyingSourceType() { result = this.getUnderlyingType() }

  Type getUnderlyingTargetType() { result = this.getConversion().getUnderlyingType() }

  int getSourceSize() {
    if this instanceof IntConstantExpr
    then result = this.(IntConstantExpr).getRequiredSizeBits()
    else result = this.getUnderlyingSourceType().getSize() * 8
  }

  int getTargetSize() { result = this.getUnderlyingTargetType().getSize() * 8 }

  predicate isSourceSignedInt() {
    if this instanceof IntConstantExpr
    then this.(IntConstantExpr).isNegative()
    else this.getUnderlyingSourceType().(IntegralType).isSigned()
  }

  predicate isTargetSignedInt() { this.getUnderlyingTargetType().(IntegralType).isSigned() }
}

class LossyImplicitConversion extends ImplicitConversion {
  LossyImplicitConversion() {
    // conversion to smaller type
    super.getTargetSize() < super.getSourceSize()
    or
    // signed to unsigned conversion
    super.isSourceSignedInt() and not super.isTargetSignedInt()
    or
    // unsigned to signed conversion without increasing size
    not super.isSourceSignedInt() and
    super.isTargetSignedInt() and
    super.getTargetSize() = super.getSourceSize()
    or
    // floating-integral conversion
    super.getUnderlyingSourceType() instanceof FloatingPointType and
    super.getUnderlyingTargetType() instanceof IntegralType
    or
    // integral-floating conversion
    super.getUnderlyingSourceType() instanceof IntegralType and
    super.getUnderlyingTargetType() instanceof FloatingPointType
  }
}

from LossyImplicitConversion lic
where
  // Conversions to bool are always fine
  not lic.getUnderlyingTargetType() instanceof BoolType
select lic,
  "AV Rule 180: implicit conversion from " + lic.getUnderlyingSourceType().toString() + " to " +
    lic.getUnderlyingTargetType().toString() + " may lose information"
