/**
 * @name Do not expose float representation
 * @description The underlying bit representation of floating point numbers should not be used in any way by the programmer. This leads to non-portable and hard to maintain code.
 * @kind problem
 * @id cpp/jsf/av-rule-147
 * @problem.severity error
 * @tags reliability
 *       external/jsf
 */

import cpp

/*
 * The bit representation of a float can be exposed by:
 *  - casting a float pointer to another pointer type
 *  - casting a float array to a non-float pointer type
 *  - using a float in a union with at least one non-float member
 */

class GeneralPointerType extends DerivedType {
  GeneralPointerType() { this instanceof PointerType or this instanceof ArrayType }
}

class InvalidFloatCastExpr extends Expr {
  InvalidFloatCastExpr() {
    exists(Type src, Type dst |
      src = this.getUnspecifiedType() and
      dst = this.getFullyConverted().getUnspecifiedType() and
      src.(GeneralPointerType).getBaseType() instanceof FloatingPointType and
      src.(GeneralPointerType).getBaseType() != dst.(GeneralPointerType).getBaseType()
    )
  }
}

class FloatUnion extends Union {
  FloatUnion() {
    exists(MemberVariable mv |
      this.getAMemberVariable() = mv and
      mv.getType().getUnderlyingType() instanceof FloatingPointType
    ) and
    exists(MemberVariable mv |
      this.getAMemberVariable() = mv and
      not mv.getType().getUnderlyingType() instanceof FloatingPointType
    )
  }

  MemberVariable getAFloatMember() {
    result = this.getAMemberVariable() and
    result.getType().getUnderlyingType() instanceof FloatingPointType
  }
}

from Element e, string message
where
  e instanceof InvalidFloatCastExpr and
  message =
    "Casting a float pointer to another pointer type exposes the bit representation of the float, leading to unportable code."
  or
  exists(FloatUnion fu | e = fu.getAFloatMember()) and
  message =
    "Defining a union with a float member exposes the bit representation of the float, leading to unportable code."
select e, message
